"use strict"
define [
  '../ng-module'
  '../utils'
], (_module, _utils, _template) ->

  _module.controllerModule
  .controller('issueListController', ($scope, $stateParams, API, $state)->
    #搜索issue
    searchIssue = ()->
      #搜索条件
      cond = {}
      cond.tag = $state.params.tag if $state.current.data?.isTag

      cond = cond || {}
      params = {}

      $scope.showQuickEditor = false
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
        $scope.showQuickEditor = true
      else
        $scope.title = "所有任务"

      #指定分类id
      params.category_id = cond.category_id if cond.category_id

      #待办中
      issueAPI = API.project($stateParams.project_id).issue()

      issueAPI.retrieve(_.extend(status: 'undone', params))
      .then (result)->
        $scope.undoneIssues = result
      #          scope.$apply()

      #加载已经完成
      issueAPI.retrieve(_.extend(status: 'done', pageSize: 10, params))
      .then (result)->
        $scope.condition = cond
        $scope.doneIssues = result
    #          scope.$apply()



    #强制重新加载数据
    $scope.$on 'issue:list:reload', (event)-> searchIssue()
    #某个issue被修改
    $scope.$on 'issue:change', ()-> searchIssue()

    searchIssue()
  )