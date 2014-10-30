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
    marked: 'vendor/marked'
    'simditor-mention': 'vendor/simditor-mention'
    'simditor-marked': 'vendor/simditor-marked'
  shim:
    'simditor-marked': ['marked', 'v/simditor']
    'simditor-mention': ['v/simditor']
    'notify': ['jquery', 'v/jquery.noty']
    ng: exports : 'angular'
    angularRoute: deps: ['ng', 'v/angular-locale_zh-cn']
    'v/jquery.transit': ['jquery', '_']
    app: ['ng', 'jquery', 'v/jquery.modal']

window.name = "NG_DEFER_BOOTSTRAP!";

require [
  "ng"
  "app"
  "routes"
], (_ng, _app, routes) ->

  _ng.element().ready ->
    $.modal.defaults.zIndex = 1000
    _ng.resumeBootstrap [_app.name]
    $('#loading').fadeOut()