define [
  '../ng-module'
  '../utils'
  't!/views/member/member-all.html'
  'pkg/jquery.autocomplete/jquery.autocomplete'
  'v/jquery.modal'
], (_module, _utils, _template, _autocomplete) ->
  _module.directiveModule
  .directive('memberSetting', ($rootScope, API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-member-setting', _template
    link: (scope, element, attr)->
      scope.activeIndex = 0
      $o = $(element)
      #接收事件后，加载数据并显示
      $rootScope.$on 'member:setting:show', (event, index)->
        scope.activeIndex = index
        $o.modal showClose: false
        scope.$broadcast "member:setting:bindAll"
      $rootScope.$on 'member:setting:hide', ()->
        $.modal.close()
  )

  .directive('memberProfile', ($location, API, NOTIFY, $rootScope)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-profile', _template
    link: (scope, element, attr)->
      #定义下属组件的上下文名称
      scope.contextName = 'memberProfile'
      scope.onClickSave = ()->
        scope.profile.gits = scope.gits
        if attr.action is 'member-profile'
          API.put('acount/profile', scope.profile).then(()->
            NOTIFY.success '保存成功！'
            scope.$emit 'member:setting:hide'
          )
        if attr.action is 'creat-member'
          scope.profile.password = '888888'
          #创建成员成功后1.关闭弹窗 2.更新本地数据. 3.添加该成员到这个项目中
          API.post('member', scope.profile).then((result)->
            NOTIFY.success '创建成员成功！'
            #1.关闭弹窗
            scope.$emit 'member:creator:hide'
            #2.更新本地数据
            $rootScope.$broadcast 'lookup:update'
            #3.添加该成员到这个项目中
            $rootScope.$broadcast 'member:created:save', result.id
          )

      scope.onClickCancel = ()->
        scope.$emit 'member:setting:hide'
        return

      scope.$on 'gitList:update', (event, name, data)->
        return if name isnt scope.contextName
        event.preventDefault()
        scope.gits = data

      scope.$on 'member:setting:bindAll', ()->
        API.get(url).then((result)->
          scope.profile = result
          scope.gits = _.map result.gits, (item)->
            item.git
        )
      scope.$on('member:creator:bindAll', (event, data)->
        scope.profile = data
        scope.$apply()
        return
      )
  )

  .directive('memberChangePassword', ($location, API, NOTIFY)->
    restrict: 'E'
    replace: true
    scope: true
    template: _utils.extractTemplate '#tmpl-member-change-password', _template
    link: (scope, element, attr)->
      url = "account/change-password"

      closeModal = ()->
        scope.$emit 'member:setting:hide'

      #校验密码
      vertify = (profile)->
        msg = ''
        if profile.old_password.length is 0
          msg = '旧密码不能为空'
        else if profile.new_password.length is 0 or profile.new_password2.length is 0
          msg = '新密码不能为空'
        else if profile.new_password isnt profile.new_password2
          msg = '两次新密码输入不一致'
        else if profile.new_password.length < 6
          msg = '密码长度必须等于大于6'
        return true if msg is ''
        NOTIFY.warn msg

      clearInput = ()->
        scope.profile = {}

      scope.onClickCancel = ()->
        closeModal()
        clearInput()
        return

      scope.onClickSave = ()->
        return if vertify(scope.profile) isnt true
        API.put(url, scope.profile).then(()->
          NOTIFY.success '修改成功！'
          closeModal()
          clearInput()
        )
        return

      clearInput()
  )

  .directive('memberNotification', ($location, API, $stateParams)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-notification', _template
    link: (scope, element, attr)->
  )
  #自动完成
  .directive('membersLookup', ($stateParams, API, $timeout)->
    restrict: 'AC'
    link: (scope, element, attrs)->
      url = "member?pageSize=1000"
      $this = $(element)
      # API.get "project/#{$stateParams.project_id}"/member (result)->

      #保存成员
      saveMember = (member_id)->
        data = {member_id : member_id, role : "d"}
        API.post("project/#{$stateParams.project_id}/member", data).then ()->
          $this.val("")
          scope.selectSuggestion = ""
          scope.$emit 'project:member:request'
          $timeout(initLookup(),100)

      #创建成员
      createMember = ()->
        value = $this.val()
        $this.val("")
        scope.$emit('member:creator:toshow', value)

      #回车事件
      $this.on "keyup", (event)->
        if event.keyCode is 13 and scope.selectSuggestion then saveMember(scope.selectSuggestion)
        if event.keyCode is 13 and not scope.selectSuggestion then createMember()

      options =
        lookup: []
        showNoSuggestionNotice: true
        noSuggestionNotice: '未找到该用户，按回车键添加该用户'
        onSelect: (suggestion)->
          scope.selectSuggestion = suggestion.data

      #处理 lookup 数据
      buildLookupData = (list) ->
        result = []
        projectMember = scope.projectMember
        _.remove(list, (item)->
          _.findIndex(projectMember, (pItem)->
            item.id is pItem.member_id) >= 0
        )
        for item in list
          result.push {value: item.realname, data: item.id}
        return result

      #初始化lookup
      initLookup = ()->
        API.get(url).then (result)->
          options.lookup = buildLookupData(result.items)
          $this.autocomplete(options)

      #当创建新成员后 初始化 lookup
      scope.$on "lookup:update", ()->
        initLookup()

      #当创建新成员后，添加这个成员到该项目
      scope.$on('member:created:save', (event, data)->
        saveMember(data)
      )
      #进入的时候初始化lookup
      initLookup()
  )
  # 添加项目成员
  .directive('memberCreatorModel', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-creator', _template
    link: (scope, element, attr)->
      $o = $(element)
      #接收事件后，加载数据并显示
      scope.$on "member:creator:show", (event, data)->
        scope.$broadcast('member:creator:bindAll', {username: data, realname: data})
        $o.modal showClose: false
      scope.$on 'member:creator:hide', ()->
        $.modal.close()
  )

