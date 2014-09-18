define [
  '../ng-module'
  '../utils'
  't!/views/issue/all.html'
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
        API.put api, status: value
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