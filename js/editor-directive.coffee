define [
  'ng-module'
  'utils'
  ''
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

      scope.$on 'editor:content', ($event, name, content)->
        #如果有设定name，且当前name和设定的name不一致，则不处理
        return if attr.name and attr.name isnt name
        initEditor() if not simditor
        simditor.focus()
        simditor.setValue content

      scope.onClickCancel = ->
        scope.$emit 'editor:cancel', attr.name

      scope.onClickSubmit = ->
        alert(attr.name)
        data =
          content: simditor.getValue()
          always_top: scope.always_top

        scope.$emit 'editor:submit', attr.name, data
  )

  #快速编辑的功能
  .directive('issueQuickEditor', (API, NOTIFY)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      scope.onKeyDown = (event)->
        return if event.keyCode isnt 13
        #处理回车
        text = _utils.trim(event.target.value)
        return if not text

        data =
          title: text
          tag: '需求' #暂时分到需求下，要根据当前所在分类
          category: attrs.category

        url = "project/#{scope.project.id}/issue"
        API.post(url, data).then((result)->
          NOTIFY.success '任务已经被成功创建'
          event.target.value = null
          #通知issue被创建
          scope.$emit 'issue:changed', 'new', result.id
        )

  )