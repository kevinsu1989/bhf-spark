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
  .controller('discussionListController', ['$scope', '$stateParams', '$location', '$filter', 'API'
  ($scope, $stateParams, $location, $filter, API)->
    $scope.condition = {}

    loadDiscussion = ()->
      API.project($stateParams.project_id).discussion()
      .retrieve($scope.condition).then (result)->
        $scope.discussion = result

    $scope.$on 'issue:change', (event, data)->
      loadDiscussion()
      return if data.status isnt 'new'

      url = "/#{$filter('projectLink')(null, 'normal')}/discussion/#{data.id}"
      $location.path(url).search('editing', 'true')

    $scope.$on 'instant-search:change', (event, value)->
      return if $scope.condition.keyword is value

      $scope.condition.keyword = value
      loadDiscussion()

    loadDiscussion()
  ])


  #评论列表
  .controller('commentListController', ($scope, $stateParams, API)->

  )

#  #文档列表
  .controller('documentListController', ['$scope', '$stateParams', '$location', '$filter', 'API',
  ($scope, $stateParams, $location, $filter, API)->
    cond = tag: 'document'

    loadDocument = ->
      API.project($stateParams.project_id).issue().retrieve(cond).then (result)->
        $scope.document = result

    $scope.$on 'issue:change', (event, data)->
      loadDocument()
#      return if data.status isnt 'new'
#      url = "/#{$filter('projectLink')(null, 'normal')}/document/#{data.id}"
#      $location.path(url).search('editing', 'true')

    loadDocument()
  ])

  .controller('documentDetailsController', ['$state', '$scope', ($state, $scope)->


  ])

