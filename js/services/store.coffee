"use strict"
define [
  'ng'
  '../ng-module'
], (_ng, _module) ->
  _module.serviceModule
  .service 'STORE', ($rootScope, $stateParams, API)->
    service =
      projectMemberList: []
      account: null

    #存储成员列表
    initProjectMemberList = ()->
      url = "project/#{$stateParams.project_id}/member"
      API.get(url).then((result)->
        service.projectMemberList = result
      )
    #存储账号信息
    initSession = ()->
      url = "session"
      API.get(url).then((result)->
        service.session = result
      )

    init = ()->
      initProjectMemberList()
      initSession()

    service.init = init
    service.initProjectMemberList = initProjectMemberList
    service.initSession = initSession
    return service