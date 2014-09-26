#全局级的directive，和模块无关
'use strict'
define [
  './../ng-module'
  '../utils'
  '_'
  't!/views/global-all.html'
  't!/views/project/all.html'
  'pkg/webuploader/webuploader.html5only'
  'pkg/datetime/datetimepicker'
  'plugin/jquery.honey.simple-tab'
], (_module, _utils, _, _template) ->
  

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
        #不用等返回
        $location.path('/login')
        API.delete 'session', ->
  ])

