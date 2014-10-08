"use strict"
define [
  'ng'
  '../ng-module'
], (_ng, _module) ->
  _module.serviceModule
  .service 'STORE', (API, $q)->

    service = {}

    class CacheData
      constructor: ()->
        @data
      update: (url)->
        self = @
        defer = $q.defer()
        API.get(url).then((result)->
          self.data = result
          defer.resolve result
        )
        defer.promise
      get: ()-> @data
      set:(data)-> @data = data

    service.projectMemberList = new CacheData()
    service.session = new CacheData()
    return service