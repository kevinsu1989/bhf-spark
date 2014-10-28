#通用的services
"use strict"
define [
  'ng'
  '../ng-module'
  'notify'
  'pkg/webuploader/webuploader.html5only'
  'moment'
], (_ng, _module, _notify, _webUploader, _moment) ->
  _module.serviceModule
  .factory 'NOTIFY', ()-> _notify

  #文件上传服务 webuploader
  .factory('WEBFILEUPLOAD',  ()->
    option =
      server : ""
    # 选择文件的按钮
      pick:
        id   : '#picker'
        multiple  : true
      auto:true
    #初始化 WebUploader
    webUploaderInit = (opt,uploaderWarp)->
      option = _.extend option, opt
      option.pick.id = uploaderWarp
      uploader = _webUploader.create option
      return uploader

    return webUploaderInit: webUploaderInit
  )

  #获取周的列表
  .factory('WEEKLIST', ()->
    (total)->
      list = []
      now = _moment().startOf 'week'
      for index in [0..total]
        start = now.clone().subtract(index, 'weeks')
        end = start.clone().add(6, 'days')
        list.push
          text: start.clone().subtract(1, 'days').format('YYYY年第W周')
          start: start.format('YYYY-MM-DD')
          end: end.format('YYYY-MM-DD')

      list
  )

