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
      $this.datetimepicker(dateOpt)

      $this.on 'changeDate', (ev)->
        scope.$emit 'datetime:change', name, ev.date.valueOf()

      $this.on 'show', ()->
        current = attrs.date
        current = new Date(Number(current)) if current
        $this.datetimepicker 'setDate', current || new Date()
#      scope.$on '$destroy', ->
#        alert('a')
#        $this.datepicker 'destroy'


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

  #周报打印
  .directive('reportWeeklyPrint', ['API', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate
    link: (scope, element, attrs)->

  ])

  #实时搜索
  .directive('instantSearch', ['$rootScope', ($rootScope)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      element.bind 'focus', (event)-> element.css(width: '90%', opacity: 1)

      element.bind 'blur', (event)-> element.css(width: '50%', opacity: 0.8)

      element.bind 'keyup', (event)->
        value = element.val()
        $rootScope.$broadcast 'instant-search:change', _utils.trim(value)
  ])

  .directive('globalMessage', [()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-global-message', _tmplGlobal
    link: (scope, element, attrs)->

  ])

  #将一个元素设置与它的父元素同样的高度
  .directive('equalParentHeight', [->
    restrict: 'A'
    link: (scope, element, attrs)->

      resetHeight = ()->
        element.css('height', element.parent().outerHeight())
      $(window).on 'onResizeEx', resetHeight
      scope.$on '$destroy', -> $(window).off 'onResizeEx', resetHeight
      resetHeight()
  ])


  .directive('fullSizeImagePreviewer', [->
    restrict: 'A'
    link: (scope, element, attrs)->
      element.bind 'click', (event)->
        $this = $(event.target)
        return if not $this.is('img')

        link = $this.attr('src')
        window.open link
  ])


