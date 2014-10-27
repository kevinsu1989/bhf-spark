'use strict'

define [
  '../ng-module'
  '../utils'
  't!/views/project/project-all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('projectMenu', ($stateParams)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu', _template
    link: (scope, element, attrs)->
      parts = ['project', $stateParams.project_id]
      if $stateParams.version_id
        parts.push 'version'
        parts.push $stateParams.version_id

      scope.baseLink = parts.join('/')
  )

  .directive('projectHeader', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-header', _template
    link: (scope, element, attrs)->

  )

  #项目成员的下拉列表
  .directive('projectMemberDropdown', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-member-dropdown', _template
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
    template: _utils.extractTemplate '#tmpl-project-tiles', _template
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

  #项目编辑器
  .directive('projectEditor', ['$rootScope', '$location', 'API', 'NOTIFY',
  ($rootScope, $location, API, NOTIFY)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-project-editor', _template
    link: (scope, element, attrs)->
      #加载项目信息
      loadProject = (project_id)->
        API.project(project_id).retrieve().then (result)->
          scope.editor_title = '编辑'

          scope.data =
            id: result.id
            gits: _.pluck result.gits, 'git'
            title: result.title
            description: result.description
            status: result.status

      scope.$on 'gitList:update', (event, name, data)->
        return if name isnt scope.contextName
        event.preventDefault()
        scope.data.gits = data

      scope.onClickDelete = (event, project_id)->
        return if not confirm('您确定将要删除这个项目吗？')
        API.project(project_id).update(status: 'trash').then ->
          $.modal.close()
          NOTIFY.success('删除成功，刷新项目列表（功能未开发）')

      scope.onClickSave = ->
        return NOTIFY.error('项目名称必需输入') if not scope.data.title
        method = if scope.data.id then 'update' else 'create'
        API.project(scope.data.id)[method](scope.data).then (result)->
          NOTIFY.success '项目信息保存成功'
          $.modal.close()
          #通知项目被改变
          $rootScope.$broadcast 'project:change', method, scope.data.id || result.id

      scope.onClickCancel = ->
        $.modal.close()
        return false

      scope.$on "project:editor:show", (event, project_id)->
        #初始化项目数据
        scope.editor_title = '新建'
        scope.contextName = 'project'
        scope.data =
          status: 'active'
          gits: []
        loadProject(project_id) if project_id
        $(element).modal showClose: false

      scope.$on 'project:editor:hide', ()->
        $.modal.close()
  ])

  .directive('projectCategoryMenu', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu-category', _template
    link: (scope, element, attrs)->

  ])

  .directive('projectCategoryDropdown', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-category-dropdown', _template
    link: (scope, element, attrs)->

  ])

  .directive('projectVersionDropdown', ['STORE', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-versions-dropdown', _template
    link: (scope, element, attrs)->
      scope.showMore = attrs.showMore is 'true'
  ])

  .directive('projectReportWeeklyMember', [->
    restrict: 'E'
    replace: true
    scope: source: '='
    template: _utils.extractTemplate '#tmpl-project-report-weekly-member', _template
    link: (scope, element, attrs)->

  ])