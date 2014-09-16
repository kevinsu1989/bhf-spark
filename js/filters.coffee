"use strict"
define [
  './ng-module'
], (_module) ->

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
      }[role]
  )