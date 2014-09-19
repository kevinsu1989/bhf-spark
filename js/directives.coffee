#全局级的directive，和模块无关
'use strict'
define [
  './ng-module'
  './utils'
  '_'
  't!/views/global-all.html'
  'plugin/jquery.honey.simple-tab'
], (_module,_utils, _, _template) ->

  _module.directiveModule

  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer

      $menus.bind 'mouseleave', -> $menus.fadeOut()
      $self.bind 'click', -> $menus.fadeIn()

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
        scope.$broadcast 'dropdown:selected', attrs.name, value
  )

  #git的列表编辑器
  .directive('gitListEditor', ->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-global-git-list', _template
    link: (scope, element, attrs)->

  )

  #tab的directive
  .directive('simpleTab', ->
    restrict: 'A'
    replace: false
    link: (scope, element, attrs)->
      $o = $(element).simpleTab()
  )

