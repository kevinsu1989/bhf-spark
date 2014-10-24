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
      return '所有版本' if not versions or not $stateParams?.version_id
      current = _.find versions, id: Number($stateParams.version_id)
      return current?.title || '未知版本'
  )

  #根据url构建项目中间的链接
  .filter('projectLink', ($stateParams)->
    (data, type)->

      hasVersion = type in ['issue', 'category-menu', 'menu', 'discussion', 'commit']
      hasCategory = type is 'issue'

      parts = []
      parts.push('project')
      parts.push($stateParams.project_id)


      if hasVersion and $stateParams.version_id
        parts.push('version')
        parts.push($stateParams.version_id)

      if type is 'issue' and $stateParams.myself
        parts.push('issue')
        parts.push('myself')

      if hasCategory and $stateParams.category_id
        parts.push('category')
        parts.push($stateParams.category_id)

      #非myself的issue，在后面添加issue目录
      if type is 'issue' and not $stateParams.myself
        parts.push('issue')

      parts.join('/')
  )