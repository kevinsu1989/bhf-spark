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
      scope.showAlwaysTop = true

      #提交评论
      submitComment = (data)->
        url = "#{scope.api}/comment"
        API.post(url, content: data.content).then (result)->
          NOTIFY.success('评论保存成功')
          #刷新数据

      scope.$watch 'issue', ->
        return if not scope.issue
        scope.api = "project/#{scope.issue.project_id}/issue/#{scope.issue.id}"

      scope.$on 'dropdown:selected', (event, type, value)->
        switch type
          when 'issue:owner' then API.put "#{scope.api}/plan", owner: value
          when 'issue:priority' then API.put "#{scope.api}/priority", priority: value

      #保存修改时间
      scope.$on 'datetime:change', (event,name,date)->
        switch name
            when 'plan_finish_time'
               API.put("#{scope.api}/plan", plan_finish_time:date).then (result)->
                 if(result) then scope.issue.plan_finish_time = date


      scope.onClickDelete = ($event)->
        alert('删除issue')

      scope.onClickEdit = ($event)->
        scope.editing = true
        #延时让页面先显示出来，然后初始化editor(仅在第一次初始化)，避免editor获取不到宽度
        window.setTimeout (->scope.$broadcast 'editor:content', editorKey, scope.issue.content), 1

      scope.$on 'editor:submit', (event, name, data)->
        #提交评论
        return submitComment(data) if name is 'comment'

        scope.editing = false
        scope.issue.content = data.content

        #保存到数据库
        newData = _.pick(scope.issue, ['content', 'title'])
        API.put(scope.api, newData).then((result)->
          NOTIFY.success('更新成功')
        )

      scope.$on 'editor:cancel', (event, name)->
        return if editorKey isnt name
        scope.editing = false
  )