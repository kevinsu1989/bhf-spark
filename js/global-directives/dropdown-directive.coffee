#git列表
'use strict'
define [
  '../ng-module'
  'utils'
], (_module, _utils) ->

  _module.directiveModule
  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer
      exclude = (attrs.excludeValue || '').split(',')

      setText = (text)->
        text = _utils.formatString attrs.formatter || '{0}', text
        $text.text text

      $menus.bind 'mouseleave', -> $menus.fadeOut()
      $self.bind 'click', (e)->
        $menus.fadeIn()
        e.stopPropagation()

        $('body').one 'click', -> $menus.fadeOut()

      attrs.$observe('selected', ->
        return if not scope.items
        selected = attrs.selected || -1
        $current = $menus.find("a[data-value='#{selected}']")

        setText $current.text()
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

        scope.$emit 'dropdown:selected', attrs.name, value

        setText $parent.text() if _.indexOf(exclude, value) is -1
  )