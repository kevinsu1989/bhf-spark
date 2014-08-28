
define [
  '../ng-module'
  '../utils'
  't!/views/project/all.html'
  '../services'
], (_module,_utils, _template) ->

  _module.directiveModule.directive('projectMenu', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu', _template
    link: (scope, element, attrs)->
  )