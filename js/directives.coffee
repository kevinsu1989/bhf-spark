#全局级的directive，和模块无关
'use strict'
define [
  './ng-module'
  './utils'
  '_'
  't!/views/global-all.html'
  't!/views/project/all.html'
  'pkg/datetime/datetimepicker'
], (_module, _utils, _, _template, _directiveTmp) ->
  _module.directiveModule

  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer

      $menus.bind 'mouseleave', ->
        $menus.fadeOut()
      $self.bind 'click', ->
        $menus.fadeIn()

      attrs.$observe('selected', ->
        return if not scope.items
        selected = attrs.selected || -1
        $current = $menus.find("a[data-value='#{selected}']")
        $text.text $current.text()
      )

      #scope.$broadcast 'dropdown:selected', attrs.name, selected


      $menus.bind 'click', (e)->
        e.stopPropagation()
        $this = $(e.target)
        $parent = $this.closest('a')
        $menus.fadeOut()

        #如果没有有指定data-value，则不处理
        value = $parent.attr('data-value')
        return if not value

        $text.text $parent.text()
        scope.$emit 'dropdown:selected', attrs.name, value
  )
  #日期选择控件
  .directive('dateTime', ()->
    restrict: 'AC'
    link: (scope, element, attr)->
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

      name = attr['name']
      type = attr['type']

      if type == 'time'
         dateOpt = timeOpt
       else if type == 'datetime'
          dateOpt = dateTimeOpt

      self = $(element);
      self.datetimepicker(dateOpt)
      self.on 'changeDate',(ev)->
           console.log ev.date.valueOf()
           scope.$emit 'datetime:change', name,ev.date.valueOf()
  )

  #git的列表编辑器
  .directive('gitListEditor', ->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-global-git-list', _template
    link: (scope, element, attrs)->
  )