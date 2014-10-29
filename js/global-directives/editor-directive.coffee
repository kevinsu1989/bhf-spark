define [
  '../ng-module'
  'utils'
  'simditor-marked'
  'simditor-mention'
], (_module,_utils) ->

  _module.directiveModule.directive('editor', ($location, STORE)->
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
          toolbar: [
            'title'          # 标题文字
            'bold'           # 加粗文字
            'italic'         # 斜体文字
            'underline'      # 下划线文字
            'strikethrough'  # 删除线文字
            'color'          # 修改文字颜色
            'ol'             # 有序列表
            'ul'             # 无序列表
            'blockquote'     # 引用
            'code'           # 代码
            'table'          # 表格
            'link'           # 插入链接
            'image'          # 插入图片
            'hr'             # 分割线
            'indent'         # 向右缩进
            'outdent'        # 向左缩进
            'marked'         # Markdown
          ]
          toolbarFloat: false
          pasteImage: true
          maxImageHeight: 2000
          maxImageWidth: 2000
          mention:
            items: STORE.projectMemberList.data
            nameKey: "username"

        new Simditor options

      scope.showAlwaysTop = attrs.showAlwaysTop in [true, 'true']
      scope.$on 'editor:content', ($event, name, content, uploadUrl)->
        #如果有设定name，且当前name和设定的name不一致，则不处理
        return if attrs.name and attrs.name isnt name
        simditor = initEditor(name, uploadUrl) if not simditor
        simditor.setValue content
        simditor.focus()

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