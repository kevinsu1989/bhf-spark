"use strict"
define [
  '../ng-module'
  '../utils'
  '../services'
], (_module, _utils, _template) ->

  _module.controllerModule.
  controller('issueDetailsController', ($rootScope, $scope, $routeParams, $location, API)->
    console.log 'abc'
  )