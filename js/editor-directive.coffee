define [
  'ng-module'
  'utils'
  'twins-editor'
], (_module,_utils) ->

  _module.directiveModule.directive('editor', ->
    restrict: 'E'
    replace: true
    templateUrl: '/views/editor.html'
    link: (scope, element, attr)->
      simditor = null

      initEditor = ->
        options =
          textarea: element.find('textarea')
          pasteImage: true

        simditor = new Simditor options
#        simditor.on 'blur', ()->
#          scope.$emit 'editor:willHide'

      scope.$on 'editor:show', ()->
        initEditor() if simditor is null
        simditor.focus()

      scope.clickCancel = ->
        scope.$emit 'editor:hide'

      scope.clickSubmit = ->
        data =
          content: simditor.getValue()
          always_top: scope.always_top

        scope.$emit 'editor:submit', data
  )