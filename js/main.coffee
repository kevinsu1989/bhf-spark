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
    select2: 'vendor/select2/select2_locale_zh-CN'
    datepicker: 'vendor/bootstrap-datepicker.zh-CN'
    'date-range-picker': 'vendor/date-range-picker'
    echarts: 'vendor/echarts'
    utils: 'utils'
    'twins-editor': 'jquery.twins-editor'
  shim:
    'v/noty': ['jquery']
    ng: exports : 'angular'
    angularRoute: deps: ['ng']
    'v/jquery.transit': ['jquery', '_']
    app: ['ng', 'jquery']
    select2: ['v/select2/select2', 'jquery']
    datepicker: ['vendor/bootstrap-datepicker']
    'twins-editor': ['jquery', 'v/simditor']

window.name = "NG_DEFER_BOOTSTRAP!";

require [
  "ng"
  "app"
  "routes"
], (_ng, _app, routes) ->

  _ng.element().ready ->
    _ng.resumeBootstrap [_app.name]