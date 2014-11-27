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
        if attr.action is 'account-profile'
          API.account().profile().update(scope.profile).then(()->
            NOTIFY.success '保存成功！'
            scope.$emit 'member:setting:hide'
          )

        if attr.action is 'create-member'
          scope.profile.password = '888888'
          #创建成员成功后1.关闭弹窗 2.更新本地数据. 3.添加该成员到这个项目中
          API.member().create(scope.profile).then((result)->
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
        API.account().profile().retrieve().then((result)->
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
      scope.profile = {}

      scope.onClickCancel = ()->
        scope.$emit 'member:setting:hide'
        return

      scope.onClickSave = ()->
        if scope.profile.new_password isnt scope.profile.new_password2
          NOTIFY.warn '您两次输入的密码不一致'
          return

        API.account().changePassword().update(scope.profile).then(()->
          NOTIFY.success '您的密码修改成功！'
          scope.profile = {}
          scope.onClickCancel()
        )
        return
  )

  .directive('memberNotification', ($location, API, $stateParams)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-notification', _template
    link: (scope, element, attr)->
  )

  #自动完成
  .directive('membersLookup', ($stateParams, API, STORE)->
    restrict: 'AC'
    link: (scope, element, attrs)->
      $this = $(element)
      memberAPI = API.project($stateParams.project_id).member()
      # API.get "project/#{$stateParams.project_id}"/member (result)->

      #保存成员
      addMember = (member_id)->
        data = {member_id: member_id, role: "d"}
        memberAPI.create(data).then ()->
          $this.val("")
          scope.selectSuggestion = ""
          scope.$emit 'project:member:request'
          initLookup()

      #创建成员
      createMember = ()->
        value = $this.val()
        $this.val("")
        scope.$emit('member:creator:toshow', value)

      #回车事件
      $this.on "keyup", (event)->
        if event.keyCode is 13 and scope.selectSuggestion then addMember(scope.selectSuggestion)
        if event.keyCode is 13 and not scope.selectSuggestion then createMember()

      options =
        lookup: []
        showNoSuggestionNotice: true
        noSuggestionNotice: '未找到该用户，按回车键添加该用户'
        onSelect: (suggestion)->
          scope.selectSuggestion = suggestion.data

      #处理 lookup 数据
      buildLookupData = (list) ->
        memberAPI.retrieve().then (projectMemberList)->
          _.remove(list, (item)->
            result = _.findIndex(projectMemberList, (pItem)->
              item.id is pItem.member_id) >= 0
            if not result
              item.value = item.realname
              item.data = item.id
              delete item.realname
              delete item.username
              delete item.id
              delete item.role

            result
          )
          
        return list

      #初始化lookup
      initLookup = ()->
        API.member().retrieve(pageSize: 9999).then (result)->
          options.lookup = buildLookupData(result.items)
          $this.autocomplete(options)

      #当创建新成员后 初始化 lookup
      scope.$on "lookup:update", ()->
        initLookup()

      #当创建新成员后，添加这个成员到该项目
      scope.$on('member:created:save', (event, data)->
        addMember(data)
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
  #项目成员item project-member-item #api/project/39/member/1
  .directive('projectMemberItem', ($stateParams, API)->
    restrict: 'AE'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-member-item', _template
    link:(scope,element,attr)->
      scope.removeProjectMember = (member)->
        API.project($stateParams.project_id).member(member.member_id).delete().then ()->
          scope.$emit 'project:member:request'
  )

  #项目成员角色 project-member-item #api/project/39/member/1/
  .directive('projectMemberRoleDropdown', ($stateParams, API)->
    restrict: 'AE'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-member-role-dropdown', _template
    link:(scope,element,attr)->
      scope.$on 'dropdown:selected', (event,name,value)->
        if 'project-member-item' is name
          API.project($stateParams.project_id).member(scope.member.member_id).update(role: value).then ()->
            scope.$emit 'project:member:request'
  )

  #读取用户的消息
  .directive('memberMessageNotifier', ($stateParams, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-message-notifier', _template
    link:(scope, element, attr)->
      $dropdown = element.find 'div.message-list'
      $dropdown.bind 'click', (event)-> event.stopPropagation()

      scope.onCloseNotifier = -> $dropdown.fadeOut()

      scope.onClickNotifier = (event)->
        event.stopPropagation()
        $dropdown.fadeIn()
        $('body').one 'click', -> scope.onCloseNotifier()
        return

      scope.onClickItem = (item, hide)->
        scope.onCloseNotifier() if hide
        API.message(item.id).update().then -> loadMessage()

      scope.onClickReadAll = ()->
        scope.onCloseNotifier()
        API.message().update().then -> loadMessage()

      #加载消息
      loadMessage = ()->
        API.message().retrieve(pageSize: 10, status: 'new').then (result)->
          scope.message = result

      loadMessage()
  )