define [
  '../ng-module'
  '../utils'
  't!/views/member/all.html'
  'v/jquery.modal'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('memberSetting', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-setting', _template
    link: (scope, element, attr)->
      $o = $(element)
      $o.modal showClose: false

      #接收事件后，加载数据并显示
      scope.$on 'member:setting:show', ()->
        $o.modal showClose: false
  )

  .directive('memberProfile', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-profile', _template
    link: (scope, element, attr)->
  )

  .directive('memberChangePassword', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-change-password', _template
    link: (scope, element, attr)->
  )

  .directive('memberNotification', ($location, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-member-notification', _template
    link: (scope, element, attr)->
  )