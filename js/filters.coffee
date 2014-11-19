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
        p: '产品'
        l: 'Leader'
        g: '客人'
        t: '测试'
      }[role]
  )

  #根据扩展名，返回对应的图片
  .filter('assetThumbnail', ->
    (asset)->
      #如果扩展名是图片，则获取缩略图
      if /\.(png|jpg|jpeg|gif|bmp)$/i.test asset.url
        url = "/api/project/#{asset.project_id}/asset/#{asset.id}/thumbnail"
        return url

      template = "/images/file-extension/file_extension_{0}.png"
      ext = if asset.url then asset.url.replace(/.+\.(\w{3,4})/i, '$1') else 'others'
      return _utils.formatString template, ext
  )

  .filter('extensionImage', ['$filter', ($filter)->
    (filename, is_dir)->
      return 'folder' if is_dir
      return 'png' if $filter('assetIsPicture')(filename)
      return 'zip' if $filter('assetIsBundle')(filename)
      'other'
  ])

  .filter('getAssetThumbnailClass', ['$filter', ($filter)->
    (url)->
      if $filter('assetIsPicture')(url) then 'thumbnail' else 'extension'
  ])

  .filter('assetIsBundle', ->
    (filename)-> /\.(7z|zip|rar)$/i.test(filename)
  )

  .filter('assetIsPicture', ->
    (url)-> /\.(png|jpg|jpeg|gif|bmp)$/i.test url
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

  .filter('wikiLink', ($stateParams)->
    (data, type)-> ['wiki', $stateParams.project_id].join('/')
  )
  #根据url构建项目中间的链接
  .filter('projectLink', ($stateParams, $state)->
    (data, type)->
      hasVersion = type in ['issue', 'normal']
      hasCategory = type is 'issue'

      #这里的逻辑有点罗，整个project link相关的代码都考虑要修改

      #wiki类型的
      if $state.current.data?.wiki
        parts = ['wiki', $stateParams.project_id]

        if hasCategory and $stateParams.category_id
          parts.push('category')
          parts.push($stateParams.category_id)

        parts.push 'issue' if type is 'issue'
        return parts.join '/'

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

  .filter('filenameIsPicture', ()->
    (filename)->
      ext = filename.replace(/.+\.(\w+)$/, '$1')
      return /^(jpg|jpeg|png|gif|bmp)$/i.test ext
  )

  .filter('replace', ->
    (value, from, to)->
      value.replace(from, to)
  )

  .filter('replaceWithRegExp', ->
    (value, from, to)->
      reg = new RegExp from
      value.replace(from, to)
  )

  .filter('lastName', ->
    (realname)-> realname.substr(0, 1)
  )

  .filter('assetLink', ->
    (asset, download)->
      return if not asset
      url = "/api/project/#{asset.project_id}/asset/#{asset.id}/read"
      url += '?download=true' if download
      url
  )

  .filter('highlightKeyword', ->
    (text, keyword)->
      return text if not keyword
      console.log keyword
      reg = new RegExp(keyword, 'ig')
      text.replace reg, "<span class='highlight'>#{keyword}</span>"
  )