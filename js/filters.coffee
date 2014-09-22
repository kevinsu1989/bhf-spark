"use strict"
define [
  './ng-module'
  './utils'
], (_module, _utils) ->

  _module.filterModule.filter('unsafe', ($sce)->
    (text)->
      $sce.trustAsHtml(text)
  )

  .filter('projectMemberRole', ()->
    (role)->
      {
        a: '管理员'
        d: '开发'
        p: '产品经理'
        l: 'Leader'
      }[role]
  )

  #根据扩展名，返回对应的图片
  .filter('extensionImage', ->
    (url)->
      template = "/images/file-extension/file_extension_{0}.png"
      ext = if url then url.replace(/.+\.(\w{3,4})/i, '$1') else 'others'
      return _utils.formatString template, ext
  )

  .filter('friendlyFileSize', ->
    (size)->
      if (size = size / 1024) < 1024
        Math.round(size * 100) / 100 + "KB"
      else if (size = size / 1024) < 1024
        Math.round(size * 100) / 100 + "MB"
      else
        Math.round(size * 100 / 1024) / 100 + "GB"
  )