define [
  '../ng-module'
  '../utils'
  't!/views/comment/comment-all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
  #评论列表
  .directive('commentList', ($stateParams, API)->
    restrict: 'E'
    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-comment-list', _template
    link: (scope, element, attr)->
      url = "project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}/comment"

      searchComment = ()->
        API.get(url, pageSize: 20).then((result)->
          scope.comments = result
        )

      #收到重新加载评论列表的事件
      scope.$on 'comment:list:reload', -> searchComment()

      searchComment()
  )

  #评论详细
  .directive('commentCell', (API)->
    restrict: 'E'
    scope: data: '=', '$index': '='
    replace: true
    template: _utils.extractTemplate '#tmpl-comment-cell', _template
    link: (scope, element, attr)->
      scope.onClickEdit = (event, comment)->
        alert('编辑')

      scope.onClickDelete = (event, comment)->
        alert('删除')
  )

  #评论的编辑框
  .directive('commentEditor', (API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-comment-editor', _template
    link: (scope, element, attrs)->
      activeClass = 'active'
      editorKey = 'comment'

      #focus后，弹出大的编辑器
      scope.onFocusEditor = ()->
        element.addClass activeClass
        scope.$broadcast 'editor:content', editorKey, null, attrs.uploadUrl
        #绑定body的one事件，点击任何地方隐藏当前
        $('body').one 'click', -> scope.$broadcast 'editor:will:cancel', editorKey
        return true

      scope.$on 'editor:cancel', (event, name)->
        return if editorKey isnt name
        element.removeClass activeClass

      scope.$on 'editor:submit', (event, name, data)->
        return if editorKey isnt name
        element.removeClass activeClass

      #阻止click的冒泡
      element.bind 'click', (e)-> e.stopPropagation()
  )