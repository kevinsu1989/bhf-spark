"use strict"
define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils) ->

  _module.controllerModule.
  controller('commitListController', ($scope, $stateParams, API)->
    cond = pageSize: 20
    url = "project/#{$stateParams.project_id}/commit"
    API.get(url, cond).then((result)->
      $scope.commit = result
    )
  )