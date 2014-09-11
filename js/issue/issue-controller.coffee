"use strict"
define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils, _template) ->

  _module.controllerModule.
  #issue明细
  controller('issueDetailsController', ($scope, $stateParams, API)->
    url = "project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}"
    API.get(url).then((result)->
      $scope.issue = result
    )
  )

  #评论列表
  .controller('commentListController', ($scope, $stateParams, API)->

  )