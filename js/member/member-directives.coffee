define [
  '../ng-module'
  '../utils'
  't!/views/member/member-all.html'
  'v/jquery.modal'
], (_module,_utils, _template) ->

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
      $rootScope.$on 'member:setting:hide', ()->
        $.modal.close()
  )

  .directive('memberProfile', ($location, API, NOTIFY)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-profile', _template
    link: (scope, element, attr)->
      url = "account/profile"
      #定义下属组件的上下文名称
      scope.contextName = 'memberProfile'

      API.get(url).then((result)->
        scope.profile = result
        scope.gits =  _.map result.gits, (item)-> item.git
      )

      scope.onClickSave = ()->
        scope.profile.gits = scope.gits
        API.put(url, scope.profile).then(()->
          NOTIFY.success '保存成功！'
          scope.$emit 'member:setting:hide'
        )

      scope.onClickCancel = ()->
        scope.$emit 'member:setting:hide'
        return

      scope.$on 'gitList:update', (event, name, data)->
        return if name isnt scope.contextName
        event.preventDefault()
        scope.gits = data

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

  .directive('memberNotification', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-notification', _template
    link: (scope, element, attr)->
  )

  .directive('memberMenu', ($rootScope)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      scope.onClickSetting = (target)->
        $rootScope.$emit 'member:setting:show', target
  )