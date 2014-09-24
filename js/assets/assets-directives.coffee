define [
  '../ng-module'
  '../utils'
  't!/views/assets/assets-all.html'
], (_module, _utils, _template) ->

  _module.directiveModule
  #上传素材
  .directive('uploadAssets', ($stateParams, API,webFileUploadService)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->

      server = "/api/project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}/assets"

      file_upload_box = angular.element('.file_upload_box')

      uploader = webFileUploadService.webUploaderInit server:server,file_upload_box

      uploader.on "uploadFinished", ()->
        scope.$emit "assets:upload:finish"
        return
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
      vm = scope.vm = action:{}
      url = "project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}/assets"
      params = pageSize: 5
      #获得附件列表
      vm.action.getAssetList = ()->
        API.get(url, params).then((result)->
          scope.assets = result
        )
      #初次进入直接拉取一次数据
      vm.action.getAssetList()
      #监听事件 assets:list:update
      scope.$on "assets:list:update",()->
        vm.action.getAssetList()
  )