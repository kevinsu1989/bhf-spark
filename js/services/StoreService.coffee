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
    initAccountInfo = ()->
      url = "account/profile"
      API.get(url).then((result)->
        service.account = result
      )

    init = ()->
      initProjectMemberList()
      initAccountInfo()

    service.init = init
    service.initProjectMemberList = initProjectMemberList
    service.initAccountInfo = initAccountInfo
    return service