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
    apiProject = API.project($stateParams.project_id)
    #获取项目的信息
    apiProject.retrieve().then((result)->
      $scope.project = result
      $rootScope.$broadcast 'project:loaded', result
    )

    #获取项目成员的信息
    apiProject.member().retrieve().then((result)->
      $scope.projectMember = result
      $scope.$broadcast 'project:member:loaded', result
    )

    STORE.initSession() if STORE.session is null
    STORE.initProjectMemberList()
  )

  #项目周报的列表
  .controller('projectWeeklyReportListController', ['API', (API)->

  ])

  #项目周报的详细
  .controller('projectWeeklyReportDetailsController', ['API', (API)->

  ])