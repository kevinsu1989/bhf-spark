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
  controller('projectController', ($rootScope, $scope, $routeParams, $location, API, $stateParams)->
    url = "project/#{$stateParams.project_id}"

    #获取项目的信息
    API.get(url).then((result)->
      $scope.project = result
      $rootScope.$broadcast 'project:loaded', result
    )

    #获取项目成员的信息
    API.get("#{url}/member").then((result)->
      $scope.projectMember = result
      $scope.$broadcast 'project:member:loaded', result
    )

  )