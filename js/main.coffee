require.config
  baseUrl: '/js'
  paths:
    ng: 'vendor/angular'
    v: 'vendor'
    jquery: 'vendor/jquery'
    _: 'vendor/lodash'
    t: 'vendor/require.text'
    moment: 'vendor/moment'
    angularRoute: 'vendor/angular-route'
    echarts: 'vendor/echarts'
    utils: 'utils'
    pkg:'/package'
  shim:
    'notify': ['jquery', 'v/jquery.noty']
    ng: exports : 'angular'
    angularRoute: deps: ['ng']
    'v/jquery.transit': ['jquery', '_']
    app: ['ng', 'jquery']

window.name = "NG_DEFER_BOOTSTRAP!";

require [
  "ng"
  "app"
  "routes"
], (_ng, _app, routes) ->

  _ng.element().ready ->
    _ng.resumeBootstrap [_app.name]
    $('#loading').fadeOut()