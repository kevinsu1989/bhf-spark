"use strict"
define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils) ->

  _module.controllerModule.
  controller('assetsListController', ($scope, $stateParams, API)->
    url = "project/#{$stateParams.project_id}/assets"
    cond = pageSize: 20
    API.get(url, cond).then((result)->
      $scope.assets = result
    )
  )