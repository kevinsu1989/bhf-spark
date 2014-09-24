'use strict'

define [
  '../ng-module'
  '../utils'
  't!/views/project/project-all.html'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('projectMenu', ()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-project-menu', _template
    link: (scope, element, attrs)->

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
  .directive('projectTiles', ($location, API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-project-tiles', _template
    link: (scope, element, attrs)->
      url = 'project'
      params =
        pageSize: 11
        special: true

      scope.onClickTile = (event, project)->
        url = "/project/#{project.id}/issue"
        $location.path(url)

      API.get(url, params).then((result)->
        scope.projects = result
      )
  )

  #项目编辑器
  .directive('projectEditor', ['$location', ($location, API)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-project-editor', _template
    link: (scope, element, attrs)->
      
  ])