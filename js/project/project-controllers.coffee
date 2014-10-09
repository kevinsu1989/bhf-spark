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
    #获取项目的信息
    projectAPI.retrieve().then((result)->
      $scope.project = result
      $rootScope.$broadcast 'project:loaded', result
    )

    #console.log STORE.projectMemberList
    #初始化获取项目成员的信息
    STORE.projectMemberList.update(projectAPI.toString() + "/member").then (result)->
      $scope.projectMember = result

    #更新成员列表信息
    $scope.$on("project:member:request", ()->
      console.log "project:member:request"
      STORE.projectMemberList.update(projectAPI.toString() + "/member").then (result)->
        $scope.projectMember = result
    )
    #展示创建成员窗口
    $scope.$on("member:creator:toshow", (event,data)->
      $scope.$broadcast("member:creator:show",data)
    )

  )

  #项目周报的列表
  .controller('projectWeeklyReportListController', ['API', (API)-> ])

  #项目周报的详细
  .controller('projectWeeklyReportDetailsController', ['API', (API)-> ])