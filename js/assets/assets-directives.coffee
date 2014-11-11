define [
  '../ng-module'
  '../utils'
  '_'
  'marked'
  't!/views/assets/assets-all.html'
  'pkg/highlight/highlight.pack'
  'pkg/colorbox/jquery.colorbox'
], (_module, _utils, _, _marked, _template) ->

  _module.directiveModule
  #上传素材
  .directive('uploadAssets', ($stateParams, API, WEBFILEUPLOAD)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      #上传地址
      server = "/api/project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}/assets"

      #用来显示上传ui组件的dom
      file_upload_box = $('.file_upload_box')

      #初始化 webFileUpload  input name 为 fileVal: "assets"
      uploader = WEBFILEUPLOAD.webUploaderInit {server: server, fileVal: "assets"}, file_upload_box

      #文件上传完 触发更新事件
      uploader.on "uploadFinished", ()->
        scope.$emit "assets:upload:finish"

      #把当前元素的点击事件代理到input type=file 的label上去 触发文件选择框  这个实现以后可以优化
      $(element).click ()->
        $(file_upload_box.find('label')).trigger('click')
      #       上传路径是：project/:project_id/issue/:issue_id/assets
      return
  )

  #素材的缩略图列表
  .directive('assetThumbnails', ($stateParams, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-asset-thumbnails', _template
    link: (scope, element, attr)->
      assetAPI = API.project($stateParams.project_id).issue($stateParams.issue_id)

      #获得附件列表
      getAssetList = ()->
        assetAPI.assets().retrieve(pageSize: 10).then (result)->
          scope.assets = result

      #删除素材
      scope.onClickRemove = (event, asset)->
        return if not confirm('您确定要删除这个素材吗？')
        assetAPI.assets(asset.id).delete().then -> getAssetList()

      scope.onClickPreviewPicture = (event, asset)->
        $(event.target).colorbox(maxWidth: 1024, photo: true)
        event.preventDefault()
        return false

      scope.onClickPreviewBundle = (event, asset)->
        scope.$emit 'asset:bundle:preview', asset.id, asset.original_name

      #监听事件 assets:list:update
      scope.$on "assets:list:update", ()-> getAssetList()

      #初次进入直接拉取一次数据
      getAssetList()
  )

  .directive('assetUnwindPreviewer', ['$sce', '$state', ($sce, $state)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-asset-unwind-previewer', _template
    link: (scope, element, attrs)->

  ])

  #预览素材文件
  .directive('assetFilePreviewer', ['$stateParams', '$http', 'API', ($stateParams, $http, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-asset-file-previewer', _template
    link: (scope, element, attrs)->

      console.log scope
      #格式化markdown
      formatMarkdown = (content)->
        scope.markdownContent = _marked(content)

      formatCode = (content)->
        obj = element.find('code')
        obj.text content
        hljs.highlightBlock obj[0]

      loadAsset = ()->
#        API.project($stateParams.project_id).assets($stateParams.asset_id).file().
        url = "/api/project/#{$stateParams.project_id}/asset/#{$stateParams.asset_id}/read"
        scope.assetUrl = url

        return if scope.assetType is 'image'

        $http.get(url).success (body)->
          switch scope.assetType
            when 'markdown' then formatMarkdown body
            when 'code' then formatCode body

      scope.$watch 'assetType', ->
        loadAsset() if scope.assetType
  ])

  #素材预览的头部
  .directive('assetPreviewerHeader', [()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-asset-previewer-header', _template
    link: (scope, element, attrs)->

  ])

  .directive('assetBundleUnwind', ['$stateParams', '$filter', 'API', ($stateParams, $filter, API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-assets-unwind', _template
    link: (scope, element, attrs)->
      scope.bundleName = ''
      scope.subdir = []

      scope.onClickNav = (event, index)->
        scope.subdir = scope.subdir.slice(0, index + 1)
        loadBundle()

      scope.onClickAsset = (event, asset)->
        #文件夹
        if asset.is_dir
          scope.subdir.push asset.original_name
          loadBundle()
          return

        #预览文件或者下载文件
#        subdir = _.clone(scope.subdir)
#        subdir.push(asset.original_name)

      scope.$on 'asset:bundle:load', (event, asset)->
        scope.asset = asset
        loadBundle()

      loadBundle = ()->
        params =
          subdir: scope.subdir.join('/')

        API.project($stateParams.project_id).assets(scope.asset.id)
        .unwind().retrieve(params).then (result)->
          _.map result, (item)->
            return if item.is_dir
            dig = "?dig=#{scope.subdir.join('/')}/#{item.original_name}"
            item.url = $filter('assetLink')(scope.asset, false) + dig

#            item.url = [
#              '/api/project/'
#              project_id
#              '/asset/'
#              scope.asset_id
#              '/read'
#              '?download=true&dig='
#              scope.subdir.join('/')
#              '/'
#              item.original_name].join('')

          scope.unwind = result
  ])