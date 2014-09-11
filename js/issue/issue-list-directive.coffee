define [
  '../ng-module'
  '../utils'
  't!/views/issue/all.html'
  '../services'
], (_module, _utils, _template) ->

  _module.directiveModule.directive('issueList', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-list', _template
    link: (scope, element, attr)->
      #搜索issue
      searchIssue = (project_id, cond)->
        url = "project/#{project_id}/issue"
        cond = cond || {}
        params = {}
        if cond.keyword #搜索
          scope.title = "搜索：#{cond.keyword}"
          params.keyword = cond.keyword
        else if cond.myself
          #获取用户自己的任务
          scope.title = "我的任务"
          params.owner = 1
        else if cond.tag
          scope.title = "标签：# {{cond.tag}} #"
          params.tag = cond.tag
        else
          scope.title = "所有任务"

        #指定分类id
        params.category_id = cond.category_id if cond.category_id

        #待办中
        API.get(url, _.extend(status: 'undone', params)).then (result)->
          scope.undoneIssues = result
#          scope.$apply()

        #加载已经完成
        API.get(url, _.extend(status: 'done', pageSize: 10, params)).then (result)->
          scope.doneIssues = result
#          scope.$apply()

      #单个项目被加载的事件
      scope.$on 'project:loaded', (event, project)-> searchIssue project.id

  )