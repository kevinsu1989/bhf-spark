define [
  '../ng-module'
  '../utils'
  't!/views/assets/assets-all.html'
], (_module, _utils, _template) ->

  _module.directiveModule
  #上传素材
  .directive('uploadAssets', ($stateParams, API)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      scope.onClickUpload = ($event, project_id)->
#       上传路径是：project/:project_id/issue/:issue_id/assets
        alert('上传素材')
  )

  #素材的缩略图列表
  .directive('assetThumbnails', ($stateParams, API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-asset-thumbnails', _template
    link: (scope, element, attr)->
      url = "project/#{$stateParams.project_id}/issue/#{$stateParams.issue_id}/assets"
      params = pageSize: 5
      API.get(url, params).then((result)->
        scope.assets = result
      )
  )