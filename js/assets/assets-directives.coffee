define [
  '../ng-module'
  '../utils'
  't!/views/assets/assets-all.html'
  'pkg/colorbox/jquery.colorbox'
], (_module, _utils, _template) ->
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

      scope.onPreview = (event, asset)->
        $(event.target).colorbox(maxWidth: 1024, photo: true)
        event.preventDefault()
        return false

      #监听事件 assets:list:update
      scope.$on "assets:list:update", ()-> getAssetList()

      #初次进入直接拉取一次数据
      getAssetList()
  )

  .directive('assetPreviewer', ['$sce', '$state', ($sce, $state)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-assets-previewer', _template
    link: (scope, element, attrs)->
      scope.url = $sce.trustAsResourceUrl($state.params.url)
  ])