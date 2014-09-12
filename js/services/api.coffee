"use strict"
define [
  'ng'
  '../ng-module'
], (_ng, _module) ->
  BASEAPI = '/api/'

  _module.serviceModule
  .factory 'API', ($http, $location, $q, NOTIFY)->
    api =
      #获取jsonp的数据
      ajax: (options)->
        #如果没有baseUrl，则加上
        options.url = "#{BASEAPI}#{options.url}" if options.url.indexOf(BASEAPI) < 0

        deferred = $q.defer()
        $http(options).success((result)->
          deferred.resolve result
        ).error((data, status) ->
          switch status
            when 404
              NOTIFY.error "找不到文件啦"
            when 500
              NOTIFY.error "大事不好了，服务器发生错误啦"
            when 406
              message = data.message or data
              NOTIFY.error "提示：" + message
            when 403
              message = data.message or data
              NOTIFY.error "你没有权限操作此项功能"
            when 401
              $location.path '/login'
            else
            #以后再考虑不同的处理
              NOTIFY.error "未知错误"

          deferred.reject null
        )

        deferred.promise

    #这段代码可以考虑优化一下
      get: (url, params)-> @ajax url: url, params: params
      post: (url, data)-> @ajax url: url, data: data, method: 'post'
      delete: (url, params)-> @ajax url: url, params: params, method: 'delete'
      put: (url, data)-> @ajax url: url, data: data, method: 'put'

      save: (url, data)->
        if data.id
          url = "#{url}/#{data.id}"
          delete data.id

        @ajax url: url, data: data

    api