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

  .directive('issueDetails', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      scope.editing = false

      scope.onClickDelete = ($event)->
        alert('删除issue')

      scope.onClickEdit = ($event)->
        scope.editing = true
        #延时让页面先显示出来，然后初始化editor(仅在第一次初始化)，避免editor获取不到宽度
        window.setTimeout (->scope.$emit 'editor:content', 'issue'), 1

      scope.$on 'editor:submit', (event, data)->
        console.log data
  )