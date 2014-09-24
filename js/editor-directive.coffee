define [
  'ng-module'
  'utils'
  'v/simditor'
], (_module,_utils) ->

  _module.directiveModule.directive('editor', ($location)->
    restrict: 'E'
    replace: true
    scope: {}
    templateUrl: '/views/editor.html'
    link: (scope, element, attrs)->
      simditor = null
      initEditor = (name, uploadUrl)->
#        用于设置返回的host，不设则为根目录
        host = "#{$location.protocol()}://#{$location.host()}:#{$location.port()}"
        options =
          textarea: element.find('textarea')
          pasteImage: true
#          defaultImage: 'images/image.png'
          params: {}
          upload:
            url: uploadUrl
            params: host: host
            connectionCount: 3
            leaveConfirm: '正在上传文件，如果离开上传会自动取消'
          tabIndent: true
          toolbar: true
          toolbarFloat: false
          pasteImage: true
          maxImageHeight: 2000
          maxImageWidth: 2000

        new Simditor options

      scope.showAlwaysTop = attrs.showAlwaysTop in [true, 'true']
      scope.$on 'editor:content', ($event, name, content, uploadUrl)->
        #如果有设定name，且当前name和设定的name不一致，则不处理
        return if attrs.name and attrs.name isnt name
        simditor = initEditor(name, uploadUrl) if not simditor
        simditor.focus()
        simditor.setValue content

      #收到cancel的请求
      scope.$on 'editor:will:cancel', (event, name)->
        #name不一致不处理
        return if attrs.name isnt name
        scope.onClickCancel()

      scope.onClickCancel = ->
        scope.$emit 'editor:cancel', attrs.name

      scope.onClickSubmit = ->
        data =
          content: simditor.getValue()
          always_top: scope.always_top

        scope.$emit 'editor:submit', attrs.name, data
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
          scope.$emit 'issue:change', 'new', result.id
        )

  )