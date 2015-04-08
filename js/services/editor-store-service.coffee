"use strict"
define [
  'ng'
  '../ng-module'
], (_ng, _module) ->
  _module.serviceModule
  .service('EDITORSTORE', ['$q', 'API', ($q, API)->

    service = {}

    class _myStorage
      constructor: ()->
        @storage=new Object();
      getItem: (key)->
        @storage[key]
      setItem: (key, string)->
        @storage[key]=string
      removeItem:(key)-> 
        delete @storage[key]

    myStorage = new _myStorage()
    service=
      get: (key)->
        myStorage.getItem key
      set: (key,string)->
        myStorage.setItem key,string
      remove: (key)->
        myStorage.removeItem key
    return service
  ])


