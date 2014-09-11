"use strict"
define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils, _template) ->

  _module.controllerModule
  .controller('issueListController', ($scope, $stateParams, API, $state)->
    #搜索issue
    searchIssue = (project_id, cond)->
      url = "project/#{project_id}/issue"
      cond = cond || {}
      params = {}
      if cond.keyword #搜索
        $scope.title = "搜索：#{cond.keyword}"
        params.keyword = cond.keyword
      else if cond.myself
        #获取用户自己的任务
        $scope.title = "我的任务"
        params.owner = 1
      else if cond.tag
        $scope.title = "标签：# #{cond.tag} #"
        params.tag = cond.tag
      else
        $scope.title = "所有任务"

      #指定分类id
      params.category_id = cond.category_id if cond.category_id

      #待办中
      API.get(url, _.extend(status: 'undone', params)).then (result)->
        $scope.undoneIssues = result
      #          scope.$apply()

      #加载已经完成
      API.get(url, _.extend(status: 'done', pageSize: 10, params)).then (result)->
        $scope.condition = cond
        $scope.doneIssues = result
    #          scope.$apply()

    #获取搜索条件
    searchCond = (->
      cond = {}
      cond.tag = $state.params.tag if $state.current.data?.isTag
      cond
    )()

    searchIssue $stateParams.project_id, searchCond
  )