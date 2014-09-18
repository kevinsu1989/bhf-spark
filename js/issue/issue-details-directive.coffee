define [
  '../ng-module'
  '../utils'
  '_'
], (_module,_utils, _) ->

  _module.directiveModule
  .directive('issueDetails', ($rootScope, API, NOTIFY)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      editorKey = 'issue'
      scope.editing = false
      scope.$watch 'issue', ->
        return if not scope.issue
        scope.api = "project/#{scope.issue.project_id}/issue/#{scope.issue.id}"

      scope.$on 'dropdown:selected', (event, type, value)->
        switch type
          when 'issue:owner' then API.put "#{scope.api}/plan", owner: value
          when 'issue:priority' then API.put "#{scope.api}/priority", priority: value

      scope.onClickDelete = ($event)->
        alert('删除issue')

      scope.onClickEdit = ($event)->
        scope.editing = true
        #延时让页面先显示出来，然后初始化editor(仅在第一次初始化)，避免editor获取不到宽度
        window.setTimeout (->scope.$broadcast 'editor:content', editorKey, scope.issue.content), 1

      scope.$on 'editor:submit', (event, type, data)->
        scope.editing = false
        scope.issue.content = data.content

        #保存到数据库
        newData = _.pick(scope.issue, ['content', 'title'])
        API.put(scope.api, newData).then((result)->
          NOTIFY.success('更新成功')
        )

      scope.$on 'editor:cancel', ()->
        scope.editing = false
  )