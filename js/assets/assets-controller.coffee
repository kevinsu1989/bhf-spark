"use strict"
define [
  '../ng-module'
  '../utils'
], (_module, _utils) ->

  _module.controllerModule.
  controller('assetsListController', ($scope, $stateParams, API)->
    cond = pageSize: 20
    API.project($stateParams.project_id).assets()
    .retrieve(cond).then((result)->
      $scope.assets = result
    )
    return
  )