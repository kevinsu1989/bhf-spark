"use strict"
define [
  '../ng-module'
  '../utils'
], (_module, _utils) ->

  _module.controllerModule.
  controller('commitListController', ($scope, $stateParams, API)->
    cond = pageSize: 20
    API.project($stateParams.project_id).commit()
    .retrieve(pageSize: 20).then((result)->
      $scope.commit = result
    )
  )

  #因gitlab的iframe策略，无法被引用
  .controller('commitDetailsController', ($scope, $sce, $state)->
    $scope.url = $sce.trustAsResourceUrl($state.params.url)
  )