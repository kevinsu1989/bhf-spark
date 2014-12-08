'use strict'

define [
  '../ng-module'
  '../utils'
  't!../../views/report/report-all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
#  周报明细中，每个用户的周报数据
  .directive('reportWeeklyDetailsMember', [->
    restrict: 'E'
    replace: true
    scope: source: '='
    template: _utils.extractTemplate '#tmpl-report-weekly-details-member', _template
    link: (scope, element, attrs)->

  ])

  .directive('reportWeeklyDetailsContent', [->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-report-weekly-details-content', _template
    link: (scope, element, attrs)->

  ])

  .directive('reportWeeklyDetailsPrint', [->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-report-weekly-details-print', _template
    link: (scope, element, attrs)->

  ])