"use strict"
###
  //临时登录用
  $.ajax({
  url: '/api/session',
  type: 'POST',
  data: {
    account: '易晓峰',
    password: '888888',
    remember: true
  }
})
###
#合集的controller，如果某个controller很大，则独立出去
define [
  '../ng-module'
  'moment'
  '_'
  '../utils'
], (_module, _moment, _, _utils, _template) ->
  _module.controllerModule.
  controller('projectController', ($rootScope, $scope, $routeParams, $location, $stateParams, API, STORE)->
    projectAPI = API.project($stateParams.project_id)

    #更新项目信息
    updateProject = ->
      #获取项目的信息
      projectAPI.retrieve().then((result)->
        $scope.project = result
        $rootScope.$broadcast 'project:loaded', result
      )

    #更新项目成员
    updateProjectMember = ->
      projectAPI.member().retrieve().then (result)->
        $scope.projectMember = result
        STORE.projectMemberList.data = result

    #更新issue的分类
    updateProjectCategory = ->
      projectAPI.category().retrieve().then (result)->
        $scope.projectCategory = result
        STORE.projectCategory.data = result

    #更新成员列表信息
    $scope.$on "project:member:request", -> updateProjectMember()
    $scope.$on "project:category:request", -> updateProjectCategory()

    #展示创建成员窗口
    $scope.$on("member:creator:toshow", (event,data)->
      $scope.$broadcast("member:creator:show",data)
    )

    updateProjectMember()
    updateProjectCategory()
    updateProject()
  )

  #项目周报的列表
  .controller('projectWeeklyReportListController', ['API', (API)-> ])

  #项目周报的详细
  .controller('projectWeeklyReportDetailsController', ['API', (API)-> ])