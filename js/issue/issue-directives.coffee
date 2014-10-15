define [
  '../ng-module'
  '../utils'
  't!/views/issue/issue-all.html'
  'v/jquery.transit'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('issueListCell', (API)->
    restrict: 'E'
#    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-list-cell', _template
    link: (scope, element, attrs)->
      #收到更改状态的通知
      scope.$on 'dropdown:selected', (event, type, value)->
        return if type isnt 'issue:status'
        api = "project/#{scope.issue.project_id}/issue/#{scope.issue.id}/status"
        API.put(api, status: value).then ()->
          scope.$emit 'issue:change', 'status', scope.issue.id

#          动画需要考虑多个问题，暂缓
#          #执行一个动画，完毕后重新加载数据
#          $obj = $("#issue-list-#{scope.issue.id}")
#          top = $('#issue-list-done').offset().top
#
#          optoins =
#            y: top
#            duration: 800
#            complete: ->
#              scope.$emit 'issue:list:reload'
#
#          $obj.transition(optoins)

  )

  .directive('issuePriorityDropdown', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-priority-dropdown', _template
    link: (scope, element, attrs)->
  )


  .directive('issueStatusDropdown', (API)->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-status-dropdown', _template
    link: (scope, element, attrs)->
      scope.$on 'dropdown:selected', ->

  )

  #快速编辑的功能
  .directive('issueQuickEditor', ['$state', '$stateParams', 'API', 'NOTIFY', ($state, $stateParams, API, NOTIFY)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      scope.onKeyDown = (event)->
        return if event.keyCode isnt 13
        #处理回车
        text = _utils.trim(event.target.value)
        return if not text

        data =
          title: text
          #暂时分到需求下，要根据当前所在分类，这个逻辑以后要改 by wvv8oo
          tag: $stateParams.tag || '需求'
          category: attrs.category

        url = "project/#{scope.project.id}/issue"
        API.post(url, data).then((result)->
          NOTIFY.success '任务已经被成功创建'
          event.target.value = null
          #通知issue被创建
          scope.$emit 'issue:change', 'new', result.id
        )
  ])


  #用户日志
  .directive('issueLog', ['$stateParams', 'API', ($stateParams, API)->
      restrict: 'E'
      replace: true
      scope: {}
      template: _utils.extractTemplate '#tmpl-issue-log', _template
      link: (scope, element, attrs)->

        API.project($stateParams.project_id)
        .issue($stateParams.issue_id)
        .log().retrieve().then (result)->
          scope.logs = result.items

  ])