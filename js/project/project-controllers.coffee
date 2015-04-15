"use strict"
#合集的controller，如果某个controller很大，则独立出去
define [
  '../ng-module'
  'moment'
  '_'
  '../utils'
], (_module, _moment, _, _utils) ->
  _module.controllerModule.
  controller('projectController', ['$rootScope', '$scope',
  '$routeParams', '$location', '$stateParams', 'API', 'STORE',
  ($rootScope, $scope, $routeParams, $location, $stateParams, API, STORE)->
    projectAPI = API.project($stateParams.project_id)

    #更新项目信息
    updateProject = ->
      #获取项目的信息
      projectAPI.retrieve().then((result)->
        $scope.project = result
        $rootScope.$broadcast 'project:loaded', result
      )

    #更新项目成员
    updateProjectMember = ->
      projectAPI.member().retrieve().then (result)->
        $scope.projectMember = result
        STORE.projectMemberList.data = result

    #更新issue的分类
    updateProjectCategory = ->
      projectAPI.category().retrieve().then (result)->
        $scope.projectCategory = result
        STORE.projectCategory.data = result

    #获取版本信息
    updateProjectVersion = ->
      projectAPI.version().retrieve(status: 'available').then (result)->
        $scope.projectVersion = result
        STORE.projectVersion.data = result
        $rootScope.$broadcast 'project:version:loaded', result

    #项目版本被选中
    projectVersionSelected = (value)->

      return alert('新建版本的功能暂未发') if value is '-1'

      url = "/project/#{$stateParams.project_id}"
      url += "/version/#{value}" if value isnt 'all'
      url += "/issue"
      $scope.$apply -> $location.path url

    #更新成员列表信息
    $scope.$on "project:member:request", -> updateProjectMember()
    $scope.$on "project:category:request", -> updateProjectCategory()

    #展示创建成员窗口
    $scope.$on("member:creator:toshow", (event,data)->
      $scope.$broadcast("member:creator:show",data)
    )

    $scope.$on 'dropdown:selected', (event, type, value)->
      switch type
        when 'project:version' then projectVersionSelected value

    win=1
    $scope.needchange=(document.body.clientWidth < 1400)
    _windowChange = (event,id)->
      $scope.needchange=(document.body.clientWidth < 1400)
      if !$scope.needchange
        $scope.leftViewStyle={'width':'40%','display':'block'}
        $scope.rightViewStyle={'display':'block'}
        win = 1
        return
      if id then win = id
      if win is 1
        $scope.leftViewStyle={'width':'100%'}
        $scope.rightViewStyle={'display':'none'}
        win = 2
      else if win is 2
        $scope.leftViewStyle={'display':'none'}
        $scope.rightViewStyle={'width':'100%'}
        win = 1

    if $scope.needchange then _windowChange(null,null)
    $scope.windowChange = ()->
      _windowChange(null,null)
    $scope.$on "project:window:change", (event, id)-> 
      _windowChange event,id


    updateProjectMember()
    updateProjectCategory()
    updateProject()
    updateProjectVersion()
  ])
