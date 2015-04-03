'use strict'

define [
  '../ng-module'
  '../utils'
  't!../../views/project/project-editors.html'
], (_module, _utils, _tmplEditors) ->

  _module.directiveModule
  #项目编辑器
  .directive('projectEditor', ['$rootScope', '$location', '$q', 'API', 'NOTIFY',
    ($rootScope, $location, $q, API, NOTIFY)->
      restrict: 'E'
      replace: true
      scope: {}
      template: _utils.extractTemplate '#tmpl-project-editor', _tmplEditors
      link: (scope, element, attrs)->
        $element = $(element)
        #git token 是否存在
        gitTokenExists = false
        #git 项目是否存在
        gitProjectExists = false

        #加载项目信息
        loadProject = (project_id)->
          deferred = $q.defer()

          params = get_git: true, get_role: true
          API.project(project_id).retrieve(params).then (result)-> deferred.resolve result

          deferred.promise

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

          #当git token不存在 并且 填写了 git 仓库名称的时候，给出警告提醒.
          if method is 'create'
            if not gitTokenExists and scope.data.gitProjectName
              return if not confirm("没有token，本项目无法自动创建仓库, 是否继续？")
              delete scope.data.gitProjectName
            if gitTokenExists and gitProjectExists
              return if not confirm("git项目已存在，无法重复创建仓库, 是否继续？")
              delete scope.data.gitProjectName

          API.project(scope.data.id)[method](scope.data).then (result)->
            NOTIFY.success '项目信息保存成功'
            $.modal.close()
            #通知项目被改变
            $rootScope.$broadcast 'project:change', method, scope.data.id || result.id

        #是否展示git相关提示信息
        scope.showGitlabStatusMsg = ->
          return false if not scope.data
          if scope.data.gitlabStatus is 'autoCreate' and scope.gitlabTokenStatusMsg?.length
            return true
          return false if scope.data.gitlabStatus is 'relevance'
          return false

        #检测git项目是否存在在自己的仓库里
        scope.checkGitlabProjectIsExist = ->
          return if not gitTokenExists
          return scope.gitlabTokenStatusMsg = "请输入仓库名称" if not scope.data.gitProjectName
          API.project().git().retrieve(name: scope.data.gitProjectName).then((data)->
            gitProjectExists = Boolean(data.exist)
            return scope.gitlabTokenStatusMsg = "仓库已存在, 请重新输入!" if data.exist
            scope.gitlabTokenStatusMsg = "仓库可用"
          )

        scope.onClickCancel = ->
          $.modal.close()
          return false

        scope.$on "project:editor:show", (event, project_id)->
          #初始化项目数据
          scope.editor_title = '新建'
          gitProjectExists = false
          scope.contextName = 'project'
          scope.data =
            status: 'active'
            gits: []
            gitlabStatus: 'relevance'

          #新建项目，直接显示弹窗
          return $element.modal(showClose: false) if not project_id

          #加载项目资料
          loadProject(project_id).then (result)->
            #检查权限，用户必需是leader或者root才能编辑项目
            return NOTIFY.error('您没有权限修改此项目') if result.role isnt 'l'

            scope.editor_title = '编辑'
            scope.data =
              id: result.id
              gits: _.pluck result.gits, 'git'
              title: result.title
              description: result.description
              status: result.status
              gitlabStatus: 'relevance'

            $element.modal(showClose: false)

        #检查git token是否存在
        API.account().profile().retrieve().then((data)->
          if not data.gitlab_token or data.gitlab_token.length is 0
            gitTokenExists = false
            scope.gitlabTokenStatusMsg = "没有git token无法自动创建，请在个人资料填写"
          else
            gitTokenExists = true
        )

        scope.$on 'project:editor:hide', -> $model.close()
  ])

  #issue分类的编辑器
  .directive('issueCategoryEditor', ['$stateParams', '$location', 'API', 'NOTIFY',
    ($stateParams, $location, API, NOTIFY)->
      restrict: 'E'
      replace: true
      scope: {}
      template: _utils.extractTemplate '#tmpl-issue-category-editor', _tmplEditors
      link: (scope, element, attrs)->
        scope.editModel = {}
        projectAPI = API.project($stateParams.project_id)

        $element = $(element)
        loadIssueCategory = (cb)->
          projectAPI.category().retrieve().then (result)->
            scope.category = result
            cb?()

        scope.onClickSave = ()->
          if not scope.editModel.title
            NOTIFY.warn('分类名称必需输入')
            return

          short_title = scope.editModel.short_title
          if short_title and not /^[\w\d_]+$/i.test(short_title)
            NOTIFY.warn('别名只能是英文数字和下划线')
            return

          method = if scope.editModel.id then 'update' else 'create'
          projectAPI.category(scope.editModel.id)[method](scope.editModel).then ->
            NOTIFY.success '分类保存成功'
            #更新数据
            loadIssueCategory()
            #清除数据
            scope.editModel = {}

        #删除
        scope.onClickDelete = (event, data)->
          return if not confirm('您确定要删除这个分类么？')
          projectAPI.category(data.id).delete().then ->
            NOTIFY.success '删除分类成功'
            loadIssueCategory()
            #如果这条数据正在编辑，则清空
            scope.editModel = {} if scope.editModel.id is data.id

        scope.onClickEdit = (event, data)->
          scope.editModel = _.pick data, 'id', 'title', 'short_title'
          return

        scope.onClickCancel = ()->
          $.modal.close()
          return

        scope.$on 'issue-category:editor:show', (event)->
          #收到数据再显示弹窗
          loadIssueCategory -> $element.modal showClose: false

        scope.$on 'issue-category:editor.hide', -> $.modal.close()
  ])

  #版本的管理
  .directive('projectVersionEditor', ['$stateParams', '$location', 'API', 'NOTIFY',
    ($stateParams, $location, API, NOTIFY)->
      restrict: 'E'
      replace: true
      scope: {}
      template: _utils.extractTemplate '#tmpl-project-version-editor', _tmplEditors
      link: (scope, element, attrs)->
        scope.editModel = {}
        projectAPI = API.project($stateParams.project_id)

        $element = $(element)
        loadProjectVersion = (cb)->
          projectAPI.version().retrieve().then (result)->
            scope.version = result
            cb?()

        scope.onClickSave = ()->
          if not scope.editModel.title
            NOTIFY.warn('版本名称必需输入')
            return

          short_title = scope.editModel.short_title
          if short_title and not /^[\w\d_]+$/i.test(short_title)
            NOTIFY.warn('别名只能是英文数字和下划线')
            return

          method = if scope.editModel.id then 'update' else 'create'
          projectAPI.version(scope.editModel.id)[method](scope.editModel).then ->
            NOTIFY.success '版本保存成功'
            #更新数据
            loadProjectVersion()
            #清除数据
            scope.editModel = {}

        #修改状态
        scope.onChangeStatus = (event, data, status)->
          projectAPI.version(data.id).update(status: status).then ->
          NOTIFY.success '状态修改成功'
          loadProjectVersion()

        #删除
        scope.onClickDelete = (event, data)->
          return if not confirm('您确定要删除这个版本么？')
          projectAPI.version(data.id).delete().then ->
            NOTIFY.success '删除版本成功'
            loadProjectVersion()
            #如果这条数据正在编辑，则清空
            scope.editModel = {} if scope.editModel.id is data.id

        scope.onClickEdit = (event, data)->
          scope.editModel = _.pick data, 'id', 'title', 'short_title', 'status'
          return

        scope.onClickCancel = ()->
          $.modal.close()
          return

        scope.$on 'project:version:editor:show', (event)->
          #收到数据再显示弹窗
          loadProjectVersion -> $element.modal showClose: false

        scope.$on 'project:version:editor.hide', -> $.modal.close()
  ])
