define [
  '../ng-module'
  '../utils'
  't!/views/assets/assets-all.html'
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
      vm = scope.vm =
        action: {}
      params =
        pageSize: 5
      #获得附件列表
      vm.action.getAssetList = ()->
        API.project($stateParams.project_id)
        .issue($stateParams.issue_id)
        .assets(params).retrieve()
        .then (result)-> scope.assets = result

      #初次进入直接拉取一次数据
      vm.action.getAssetList()
      #监听事件 assets:list:update
      scope.$on "assets:list:update", ()->
        vm.action.getAssetList()
  )

  .directive('assetPreviewer', ['$sce', '$state', ($sce, $state)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-assets-previewer', _template
    link: (scope, element, attrs)->
      scope.url = $sce.trustAsResourceUrl($state.params.url)
  ])