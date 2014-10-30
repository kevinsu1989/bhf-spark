'use strict'

define [
  '../ng-module'
  '../utils'
  't!/views/project/project-all.html'
  't!/views/project/project-editors.html'
], (_module,_utils, _tmplAll, _tmplEditors) ->

  _module.directiveModule
  .directive('projectMenu', ($rootScope, $stateParams)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu', _tmplAll
    link: (scope, element, attrs)->
      parts = ['project', $stateParams.project_id]
      if $stateParams.version_id
        parts.push 'version'
        parts.push $stateParams.version_id

      scope.baseLink = parts.join('/')

      scope.$on 'dropdown:selected', (event, type, value)->
        return if type isnt 'project:menu:manage'
        switch value
          when 'category' then $rootScope.$broadcast 'issue-category:editor:show'
          when 'version' then $rootScope.$broadcast 'project:version:editor:show'
  )

  .directive('projectHeader', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-header', _tmplAll
    link: (scope, element, attrs)->

  )

  #项目成员的下拉列表
  .directive('projectMemberDropdown', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-member-dropdown', _tmplAll
    link: (scope, element, attrs)->
      loaded = false

      #获取到数据后，调用dropdown
      attrs.$observe('items', ->
        #异步获取数据时，items可能还没有赋值，也可能被多次赋值
        return if loaded or not attrs.items
        loaded = true
        scope.items = JSON.parse(attrs.items)
      )
  )

  #项目列表
  .directive('projectTiles', ['$location', '$rootScope', 'API', 'NOTIFY',
  ($location, $rootScope, API, NOTIFY)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-project-tiles', _tmplAll
    link: (scope, element, attrs)->
      params =
        pageSize: 9999
        special: true

      scope.onClickCreate = ->
        #弹出项目编辑器
        $rootScope.$broadcast 'project:editor:show'

      scope.onClickTile = (event, project)->
        url = "/project/#{project.id}"
        url += "/version/#{project.active_version}" if project.active_version
        url += "/issue"
        $location.path(url)

      scope.onClickEdit = (event, project)->
        event.stopPropagation()
        $rootScope.$broadcast 'project:editor:show', project.id
        return

      scope.onClickDelete = (event, project)->
        event.stopPropagation()
        return if not confirm('您确定要删除该项目吗？')

        #将项目状态设置为trash
        API.project(project.id).update(status: 'trash').then ->
          $tile = $(event.target).closest('li.tile')
          $tile.fadeOut()
          #通知用户
          NOTIFY.success '该项目已经删除成功'


      API.project().retrieve(params).then((result)->
        scope.projects = result
      )
  ])


  .directive('projectCategoryMenu', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu-category', _tmplAll
    link: (scope, element, attrs)->

  ])

  .directive('projectCategoryDropdown', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-category-dropdown', _tmplAll
    link: (scope, element, attrs)->

  ])

  .directive('projectVersionDropdown', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-versions-dropdown', _tmplAll
    link: (scope, element, attrs)->
      scope.showMore = attrs.showMore is 'true'
  ])
