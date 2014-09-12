define [
  '../ng-module'
  '../utils'
], (_module,_utils) ->

  _module.directiveModule
  #上传素材
  .directive('uploadAssets', ($stateParams, API)->
    restrict: 'A'
    replace: true
    link: (scope, element, attr)->
      scope.onClickUpload = ($event, project_id)->
        alert('上传素材')
  )