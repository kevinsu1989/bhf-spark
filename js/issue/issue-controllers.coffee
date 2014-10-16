"use strict"
define [
  '../ng-module'
  '../utils'
], (_module, _utils, _template) ->

  _module.controllerModule.
  #issue明细
  controller('issueDetailsController', ($scope, $stateParams, API, $state)->
    $scope.articleOnly = $state.current.data?.articleOnly

    API.project($stateParams.project_id)
    .issue($stateParams.issue_id)
    .retrieve().then((result)->
      $scope.issue = result
      $scope.notFound = !result
    )

    $scope.$on "assets:upload:finish", ()->
      $scope.$broadcast "assets:list:update"
      return
  )

  #讨论列表
  .controller('discussionListController', ($scope, $stateParams, API)->
    API.project($stateParams.project_id).discussion().retrieve().then (result)->
      $scope.discussion = result
  )


  #评论列表
  .controller('commentListController', ($scope, $stateParams, API)->

  )