define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils) ->

  _module.directiveModule
  .directive('issueDetails', ($rootScope, API)->
    restrict: 'E'
    replace: true
    templateUrl: '/views/issue/details.html'
    link: (scope, element, attr)->

      scope.$on 'issue:details:load', (event, project_id, issue_id)->
        scope.$broadcast 'comment:load', project_id, issue_id
        API.get("project/#{project_id}/issue/#{issue_id}").then((result)->
          scope.issue = result
          scope.$apply()
        )
  )