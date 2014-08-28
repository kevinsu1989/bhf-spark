"use strict"
define [
  './ng-module'
], (_module) ->
  _module.filterModule.filter('unsafe', ($sce)->
    (text)->
      $sce.trustAsHtml(text)
  )