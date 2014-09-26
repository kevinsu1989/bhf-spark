#通用的services
"use strict"
define [
  'ng'
  '../ng-module'
  'notify'
], (_ng, _module, _notify) ->
  _module.serviceModule
  .factory('NOTIFY', ()-> _notify)