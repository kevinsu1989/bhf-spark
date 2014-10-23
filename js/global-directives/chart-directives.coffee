define [
  '../ng-module'
  'utils'
  'moment'
  '../chart/project-finished-total'
], (_module, _utils, _moment, _ProjectFinishedTotal)->

  _module.directiveModule
  #项目中，issue完成数量的TOP5
  .directive('issueFinishedTotalChart', ['API', (API)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      chart = new _ProjectFinishedTotal(element[0])
      beginTime = _moment('2014-05-01')
      startTime = _moment().subtract(1, 'years').startOf('day')
      #不能在最初的时间前
      startTime = beginTime if startTime.isBefore(beginTime)
      endTime = _moment().endOf('day')

      params =
        startTime: startTime.valueOf()
        endTime: endTime.valueOf()

      API.report()[attrs.name]().issueFinish()
        .retrieve(params).then (result)->
          chart.reload startTime, endTime, result
  ])

  #成员issue完成数据的TOP5
  .directive('memberFinishedTotalChart', ()->
    restrict: 'E'
    replace: true
    link: (scope, element, attrs)->
  )