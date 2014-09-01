define [
  '../ng-module'
  '../utils'
  't!/views/comment/all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
  #评论列表
  .directive('commentList', (API)->
    restrict: 'E'
    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-comment-list', _template
    link: (scope, element, attr)->

      scope.$on 'comment:load', (event, project_id, issue_id)->
        url = "project/#{project_id}/issue/#{issue_id}/comment"

        API.get(url, pageSize: 20).then((result)->
          scope.comments = result
          scope.$apply()
        )
  )

  #评论详细
  .directive('commentCell', (API)->
    restrict: 'E'
    scope: data: '=', '$index': '='
    replace: true
    template: _utils.extractTemplate '#tmpl-comment-cell', _template
    link: (scope, element, attr)->
      console.log scope
  )