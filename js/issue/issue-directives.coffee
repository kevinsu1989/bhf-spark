define [
  '../ng-module'
  '../utils'
  't!/views/issue/issue-all.html'
  'v/jquery.transit'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('issueListCell', (API)->
    restrict: 'E'
#    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-list-cell', _template
    link: (scope, element, attrs)->
      #收到更改状态的通知
      scope.$on 'dropdown:selected', (event, type, value)->
        return if type isnt 'issue:status'
        api = "project/#{scope.issue.project_id}/issue/#{scope.issue.id}/status"
        API.put(api, status: value).then ()->
          scope.$emit 'issue:change', 'status', scope.issue.id

#          动画需要考虑多个问题，暂缓
#          #执行一个动画，完毕后重新加载数据
#          $obj = $("#issue-list-#{scope.issue.id}")
#          top = $('#issue-list-done').offset().top
#
#          optoins =
#            y: top
#            duration: 800
#            complete: ->
#              scope.$emit 'issue:list:reload'
#
#          $obj.transition(optoins)

  )

  .directive('issuePriorityDropdown', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-priority-dropdown', _template
    link: (scope, element, attrs)->
  )


  .directive('issueStatusDropdown', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-status-dropdown', _template
    link: (scope, element, attrs)->
      scope.$on 'dropdown:selected', ->

  )