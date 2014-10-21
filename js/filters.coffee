"use strict"
define [
  './ng-module'
  './utils'
  'moment'
], (_module, _utils, _moment) ->

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
        g: '客人'
        t: '测试'
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

  .filter('rawText', ()->
    (html)->
      div = document.createElement('div')
      div.innerHTML = html
      #div.innerText
      $(div).text()
  )

  .filter('timeAgo', -> (date)-> _moment(date).fromNow())

  #获取当前项目的版本
  .filter('currentProjectVersion', ($stateParams)->
    (versions)->
      return if not versions or not $stateParams
      current = _.find versions, id: Number($stateParams.version_id)
      return current?.title
  )