"use strict"
#合集的controller，如果某个controller很大，则独立出去
define [
  '../ng-module'
  'moment'
  '_'
  '../utils'
], (_module, _moment, _, _utils) ->

  _module.controllerModule
  #项目周报的列表
  .controller('weeklyReportListController', ['$scope', 'API', 'WEEKLIST',
    ($scope, API, WEEKLIST)->
      $scope.weeks = WEEKLIST(30)
  ])

  #项目周报的详细
  .controller('reportWeeklyDetailsController', ['$rootScope', '$scope', '$stateParams', '$location', 'API',
    ($rootScope, $scope, $stateParams, $location, API)->
      start_time = $stateParams.start_time || $location.$$search.start_time
      end_time = $stateParams.end_time || $location.$$search.end_time

      console.log start_time
      console.log(_moment(start_time, 'YYYY-MM-DD').format('YYYY-MM-DD'))
      cond =
        start_time: _moment(start_time).startOf('week').valueOf()
        end_time: _moment(end_time).endOf('week').valueOf()

      _.extend $scope, cond

      API.report().weekly().retrieve(cond).then (result)->
        $scope.report = result
  ])