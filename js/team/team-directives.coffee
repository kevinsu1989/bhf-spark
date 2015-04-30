'use strict'

define [
  '../ng-module'
  '../utils'
  't!../../views/team/team-all.html'
  'v/circles'
], (_module,_utils, _tmplAll) ->

  _module.directiveModule.directive('teamCategoryMenu', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-team-menu-category', _tmplAll
    link: (scope, element, attrs)->

  ])
  .directive('teamMenuBar', [()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-team-menu-bar', _tmplAll
    link: (scope, element, attrs)->
    	
  ])
  .directive('teamCreate', ['API', (API)->
    restrict: 'AC'
    link: (scope, element, attrs)->
      $this = $(element) 
      addTeam = (member_id)->
        data = {name: $this.val()}
        API.team().create(data).then (team)->
          window.location.href = "/team/#{team.id}/list?title=#{team.name}"
      $this.on "keyup", (event)->
        if event.keyCode is 13 and $this.val() then addTeam()	
  ])
				
  .directive('teamSetting', ['API', 'NOTIFY', (API, NOTIFY)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-team-setting', _tmplAll
    link: (scope, element, attr)->
      $o = $(element)
      #接收事件后，加载数据并显示
      scope.$on 'team:setting:show', (event, name, id)->
        $o.modal showClose: false
        scope.profile = 
          teamName: name
          team_id: id
        console.log scope.profile
      scope.$on 'team:setting:hide', ()->
        $.modal.close()


      scope.onClickCancel = ()->
        $.modal.close()

      scope.onClickSave = ()->
        return if scope.profile.teamName is scope.title
        entity =
          name: scope.profile.teamName
        API.team(scope.profile.team_id).update(entity).then (result)->
          NOTIFY.success '修改成功！'
          scope.profile = {}
          $.modal.close()

      scope.onClickDelete = ()->
        scope.$emit "team:remove" if confirm "要不要再考虑一下呢？" if confirm "你真的确定要删除该团队了吗？" if confirm "删除团队后，团队的成员关系将不复存在，请慎重操作！"
        
  ])