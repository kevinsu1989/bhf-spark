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
    app: ['ng', 'jquery']
    'v/jquery.modal': 'jquery'

window.name = "NG_DEFER_BOOTSTRAP!";

require [
  "ng"
  "app"
  "routes"
  'jquery'
], (_ng, _app, routes) ->

  (->
    timer = null
    $window = $(window).resize(->
      timer = setTimeout(->
        $window.trigger "onResizeEx"
      , 500)
  )
  )()

  #检测不支持的浏览器
  (->
#    ua = window.navigator.userAgent
#    if /safari|msie/i.test(ua) and not /chrome/i.test(ua)
#    console.log browser
    if not (browser.firefox or browser.chrome or browser.webkit)
      $('#loading').fadeOut()
      alert('很抱歉，我们暂时不能支持您的浏览器')
      return

    _ng.element().ready ->
      _ng.resumeBootstrap [_app.name]
      $('#loading').fadeOut()
  )()

