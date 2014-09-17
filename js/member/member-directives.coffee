define [
  '../ng-module'
  '../utils'
  't!/views/member/all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('memberSetting', ($location, API)->
    restrict: 'E'
    replace: false
    template: _utils.extractTemplate '#tmpl-member-setting', _template
    link: (scope, element, attr)->
  )