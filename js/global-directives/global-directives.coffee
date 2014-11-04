#全局级的directive，和模块无关
'use strict'
define [
  './../ng-module'
  '../utils'
  '_'
  't!/views/global-all.html'
  't!/views/project/project-all.html'
  'v/keyboard'
  'pkg/webuploader/webuploader.html5only'
  'pkg/datetime/datetimepicker'
  'plugin/jquery.honey.simple-tab'
], (_module, _utils, _, _tmplGlobal, _template, _keybroad) ->


  _module.directiveModule
  #日期选择控件
  .directive('datetimePicker', ()->
    restrict: 'AC'
    link: (scope, element, attrs)->
      dateOpt =
        format: 'yyyy-MM-dd'
        startView: 2
        minView: 2

      timeOpt =
        format: 'hh:mm:ss'
        startView: 1
        minView: 0
        maxView: 1

      dateTimeOpt =
        format: 'yyyy-MM-dd HH:mm:ss'
        startView: 2

      name = attrs.name
      type = attrs.type
      formart = attrs.formart

      #判断类型
      switch type
        when 'time' then dateOpt = timeOpt
        when 'datetime'then dateOpt = dateTimeOpt

      #设定默认值
      dateOpt.showMeridian = true
      dateOpt.autoclose = true
      if formart then dateOpt.formart = formart

      $this = $(element);
      $this.click ()->
        $this.datetimepicker(dateOpt)
        $this.on 'changeDate', (ev)->
          scope.$emit 'datetime:change', name, ev.date.valueOf()
  )

  #tab的directive
  .directive('simpleTab', ()->
    restrict: 'A'
    replace: false
    link: (scope, element, attrs)->
      $o = $(element).simpleTab()
      attrs.$observe 'activeIndex', ()->
        $o.simpleTab 'change', parseInt(attrs.activeIndex)
  )

  #header上的toolbar
  .directive('headerToolbar', ['$rootScope', '$location', 'API', ($rootScope, $location, API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate('#tmpl-global-header-toolbar', _tmplGlobal)
    link: (scope, element, attrs)->

      scope.onClickSetting = (target)->
        $rootScope.$emit 'member:setting:show', target

      scope.onClickLogout = ()->
        API.session().delete().then -> $location.path('/login')
  ])
  #快捷键
  #<button hot-key  data-key="enter" ng-click="onClickSubmit()">
  #data-key="keyCombo" 你要绑定快捷键  每次绑定前都会清理该键的相关事件
  # keyCombo  "a" 绑定a  ;"a,b"|"a b"  a or b; 'a + b' a and b
  #vist http://robertwhurst.github.io/KeyboardJS/  get more info
  .directive('hotKey', [()->
      restrict: 'A'
      link: (scope, element, attrs)->
        key = attrs.key
        #清理事件
        _keybroad.clear.key(key)
        onDownCallback = ()->
        onUpCallback   = ()->
          $(element).click()
        _keybroad.on(key, onDownCallback, onUpCallback)
  ])

  .directive('reportWeeklyPrint', ['API', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate
    link: (scope, element, attrs)->
      console.log 'abc'

  ])
