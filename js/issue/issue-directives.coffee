define [
  '../ng-module'
  '../utils'
  't!/views/issue/all.html'
  '../services'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('issueListCell', ->
    restrict: 'E'
    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-list-cell', _template
    link: (scope, element, attr)->

  )