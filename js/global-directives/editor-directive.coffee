define [
  '../ng-module'
  'utils'
  'v/store2'
  'simditor-marked'
  'simditor-mention'
], (_module, _utils, _store) ->

  _module.directiveModule.directive('editor', ['$location', '$timeout', 'STORE',
  ($location, $timeout, STORE)->
    restrict: 'E'
    replace: true
    scope: {}
    templateUrl: '/views/editor.html'
    link: (scope, element, attrs)->
      simditor = null
      currentUUID = null

      #获取缓存的key
      getCacheKey = (name, uuid)-> "#{name}_#{uuid}"
      #检查是否有缓存的内容
      getCache = (name, uuid)-> _store.get getCacheKey(name, uuid)
      #设置缓存
      setCache = (name, uuid, content)-> _store.set getCacheKey(name, uuid), content
      #删除缓存
      removeCache = (name, uuid)-> _store.remove getCacheKey(name, uuid)

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

        editor = new Simditor options

        editor.on 'valuechanged', (e, src)->
          content = e.currentTarget.getValue()
          setCache attrs.name, currentUUID, content

        editor

      scope.showAlwaysTop = attrs.showAlwaysTop in [true, 'true']
      scope.$on 'editor:content', ($event, name, uuid, content, uploadUrl)->
        #如果有设定name，且当前name和设定的name不一致，则不处理
        return if attrs.name and attrs.name isnt name
        currentUUID = uuid

        if not simditor then simditor = initEditor(name, uploadUrl)

        simditor.setValue getCache(name, uuid) || content
        #第二打开评论编辑器，如果有focus会报错，暂是不使用这个
        #simditor.focus()
        return

      #收到cancel的请求
      scope.$on 'editor:will:cancel', (event, name)->
        #name不一致不处理
        return if attrs.name isnt name
        #如果是从外部传到的取消请求，则再保存一次数据
        setCache attrs.name, currentUUID, simditor.getValue()

        scope.$emit 'editor:cancel', attrs.name

      scope.onClickCancel = ->
        #用户自主点击取消的，要移除缓存
        removeCache attrs.name, currentUUID

        scope.$emit 'editor:cancel', attrs.name

      scope.onClickSubmit = ->
        data =
          content: simditor.getValue()
          always_top: scope.always_top

        removeCache attrs.name, currentUUID
        scope.$emit 'editor:submit', attrs.name, data
  ])