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

  .controller('assetsDetailsController', ['$scope', '$stateParams', '$filter', 'API',
  ($scope, $stateParams, $filter, API)->
    API.project($stateParams.project_id).issue(0).assets($stateParams.asset_id).retrieve().then (result)->
      #压缩文件
      if $scope.assetIsBundle = $filter('assetIsBundle')(result.file_name)
        $scope.bundleName = result.original_name
        $scope.$broadcast 'asset:bundle:load', result.id, result.original_name
      else
        $scope.assetType = _utils.detectFileType result.original_name
        $scope.asset = result
  ])