define [
  '../ng-module'
  '../utils'
  't!/views/member/all.html'
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

  .directive('memberMenu', ($rootScope)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      scope.onClickSetting = (target)->
        $rootScope.$emit 'member:setting:show', target
  )