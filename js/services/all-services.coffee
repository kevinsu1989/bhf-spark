#通用的services
"use strict"
define [
  'ng'
  '../ng-module'
  'notify'
], (_ng, _module, _notify) ->
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

