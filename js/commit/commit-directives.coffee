define [
  '../ng-module'
  'utils'
  't!/views/commit/commit-all.html'
], (_module, _utils, _template)->

  _module.directiveModule
  .directive('commitIssueList', ['$stateParams', 'API', ($stateParams, API)->
    restrict: 'E'
    replace: true
    scope: false
    template: _utils.extractTemplate '#tmpl-commit-issue-list', _template
    link: (scope, element, attrs)->
      loadCommitList = ()->
        API.project($stateParams.project_id).issue($stateParams.issue_id)
        .commit().retrieve(pageSize: 9999).then (result)->
          scope.commits = result.items

      loadCommitList()
  ])