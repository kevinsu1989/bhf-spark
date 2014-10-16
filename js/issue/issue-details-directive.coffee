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
      issueAPI = null

      scope.editing = false
      scope.showAlwaysTop = true

      #提交评论
      submitComment = (data)->
        issueAPI.comment().create(content: data.content).then (result)->
          NOTIFY.success('评论保存成功')
          #刷新评论数据
          scope.$broadcast 'comment:list:reload'

      #阻止此区域的事件冒泡，
      scope.onClickIssue = (event)->
        event.stopPropagation() if scope.editing
        return

      scope.$watch 'issue', ->
        return if not scope.issue
        issueAPI = API.project(scope.issue.project_id).issue(scope.issue.id)
        scope.uploadUrl = "/api/project/#{scope.issue.project_id}/attachment"

      scope.$on 'dropdown:selected', (event, type, value)->
        switch type
          when 'issue:owner' then issueAPI.plan().update(owner: value)
          when 'issue:priority' then issueAPI.priority().update(priority: value)

      #保存修改时间
      scope.$on 'datetime:change', (event,name,date)->
        switch name
            when 'plan_finish_time'
              issueAPI.plan().update(plan_finish_time:date).then (result)->
                 if(result) then scope.issue.plan_finish_time = date


      scope.onClickDelete = ()->
        issueAPI.status().update(status : 'trash').then ()->
          NOTIFY.success '删除成功'
          $rootScope.$broadcast 'issue:change'

      scope.onClickEdit = ($event)->
        scope.editing = true
        #延时让页面先显示出来，然后初始化editor(仅在第一次初始化)，避免editor获取不到宽度
        window.setTimeout(->
          scope.$broadcast 'editor:content', editorKey, scope.issue.content, scope.uploadUrl
        , 1)

        $('body').one 'click', -> scope.$broadcast 'editor:will:cancel', editorKey
        return

      scope.$on 'editor:submit', (event, name, data)->
        #提交评论
        return submitComment(data) if name is 'comment'

        scope.editing = false
        scope.issue.content = data.content

        #保存到数据库
        newData = _.pick(scope.issue, ['content', 'title'])
        issueAPI.update(newData).then((result)->
          NOTIFY.success('更新成功')
        )

      scope.$on 'editor:cancel', (event, name)->
        return if editorKey isnt name
        scope.editing = false
        scope.$apply() if not scope.$$phase
  )