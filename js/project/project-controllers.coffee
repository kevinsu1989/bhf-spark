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
  '../services'
], (_module, _moment, _, _utils, _template) ->

  _module.controllerModule.
  controller('projectController', ($rootScope, $scope, $routeParams, $location, API)->
    $scope.showDetails = Boolean(issue_id = $routeParams.issue_id)
    url = "project/#{$routeParams.project_id}"

    API.get(url).then((result)->
      $rootScope.$broadcast 'project:loaded', result

      if $scope.showDetails
        $rootScope.$broadcast 'issue:details:load', $routeParams.project_id, issue_id
    )


  )