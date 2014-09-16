'use strict'

define [
  'ng'
  './services/index'
  'filters'
  './editor-directive'
  './project/index'
  './issue/index'
  './comment/index'
  './member/index'
  './commit/index'
  './assets/index'
  'angularRoute'
  'v/ui-router'
  './directives'
], (_ng) ->
  _ng.module 'mic', [
    'ngRoute'
    'mic.services'
    'mic.directives'
    'mic.controllers'
    'mic.filters'
    'ui.router'
  ]