"use strict"

define [
  "ng"
  "services"
  "filters"
  './editor-directive'
  "./project/index"
  "./issue/index"
  "./comment/index"
  "angularRoute"
], (_ng) ->
  _ng.module "mic", [
    "ngRoute"
    "mic.services"
    "mic.directives"
    "mic.controllers"
    "mic.filters"
  ]