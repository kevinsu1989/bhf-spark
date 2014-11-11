"use strict"
define [
  '../ng-module'
  '../utils'
  '_'
], (_module, _utils, _) ->

  _module.controllerModule.
  controller('assetsListController', ($scope, $stateParams, API)->
    $scope.condition = {}

    searchAssets = (query)->
      $scope.condition = _.extend {pageSize: 20}, query
      API.project($stateParams.project_id).assets()
      .retrieve($scope.condition).then((result)->
        $scope.assets = result
      )

    $scope.$on 'instant-search:change', (event, keyword)->
      return if $scope.condition.keyword is keyword
      searchAssets keyword: keyword

    searchAssets()
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