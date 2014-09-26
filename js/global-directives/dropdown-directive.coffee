#git列表
'use strict'
define [
  '../ng-module'
], (_module) ->

  _module.directiveModule
  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer

      $menus.bind 'mouseleave', -> $menus.fadeOut()
      $self.bind 'click', (e)->
        $menus.fadeIn()
        e.stopPropagation()

        $('body').one 'click', -> $menus.fadeOut()

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