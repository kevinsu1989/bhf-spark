define [
  '../ng-module'
  '../utils'
  't!../../views/issue/issue-all.html'
  'v/jquery.transit'
], (_module,_utils, _template) ->

  _module.directiveModule
  .directive('issueListCell', ['API', (API)->
    restrict: 'E'
#    scope: data: '='
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-list-cell', _template
    link: (scope, element, attrs)->
      #点击状态
      scope.onClickStatus = (event, issue)->
        scope.$emit 'issue:status-dropdown:show', event, issue
        return

      scope.getDelayClass = (issue)->
        if issue.plan_finish_time and
          issue.status isnt 'done' and
          issue.plan_finish_time < new Date().valueOf() then 'delay' else ''

      #收到更改状态的通知
      scope.$on 'dropdown:selected', (event, type, value)->
        return if type isnt 'issue:status'
        #"project/#{scope.issue.project_id}/issue/#{scope.issue.id}/status"
        API.project(scope.issue.project_id).issue(scope.issue.id).update(status : value).then ()->
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

  ])

  .directive('issuePriorityDropdown', [()->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-priority-dropdown', _template
    link: (scope, element, attrs)->
  ])

  #issue的下拉列表
  .directive('issueStatusDropdown',[()->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-issue-status-dropdown', _template
    link: (scope, element, attrs)->

  ])

  #issue 状态下拉列表，下拉列表必需已经存在容器内容，并且可以通过find('div.dropdown.status')找得到
  .directive('issueStatusDropdownAction',[()->
    restrict: 'A'
    replace: false
#    scope: {}
#    template: _utils.extractTemplate '#tmpl-issue-status-dropdown', _template
    link: (scope, element, attrs)->
      $dropdown = null
      currentIssue = null

      scope.$on 'issue:status-dropdown:show', (ngEvent, event, issue)->
        event.stopPropagation()
        currentIssue = issue
        statusVisibility issue

        $this = $(event.target)
        position = $this.position()
        position.top += $this.height()
        position.left -= 6;
        $dropdown.css(position).fadeIn()
        $('body').one 'click', -> $dropdown.fadeOut()
        return

      initDropdown = ()->
        return if $dropdown

        $dropdown = element.find 'div.dropdown.status'
        $dropdown.bind 'mouseleave', -> $dropdown.fadeOut()
        $dropdown.find('a').bind 'click', ()->
          $this = $(this)
          value = $this.attr 'data-value'
          scope.$emit 'issue:status:change', currentIssue.id, currentIssue.status, value

      #设置状态是否可视
      statusVisibility = (issue)->
        isTest = issue.tag is 'test'
        displayRules =
          doing: true
          pause: issue.status isnt 'done'
          repaired: isTest and issue.status is 'repairing'
          repairing: isTest and issue.status in ['doing', 'reviewing', 'repaired']
          reviewing: isTest and issue.status in ['doing', 'repairing', 'repaired']
          done: not isTest and issue.status isnt 'done'
          reviewed: isTest and issue.status is 'reviewing'


        initDropdown()
        $dropdown.find('li').each ()->
          $this = $(this)
          value = $this.attr('data-status')
          $this.toggle displayRules[value]

  ])

  #快速编辑的功能
  .directive('issueQuickEditor', ['$state', '$stateParams', '$location', '$timeout', '$rootScope', 'API', 'NOTIFY',
  ($state, $stateParams, $location, $timeout, $rootScope, API, NOTIFY)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
#      console.log($location)
      titleMap =
        issue: '任务'
        document: '文档'
        discussion: '讨论'
        test: '测试'

      #跳转到具体的issue
      gotoIssue = (issue_id)->
        #替换掉url后面可能存在的id
        url = $location.$$path.replace(/(.+)(\/\d+)$/, '$1') + '/' + issue_id
        $location.path(url)

        #延时打开编辑器，但这样做好吗？
        #这个地方的问题在于，跳转到url后，需要加载完issue，才能显示editor，这样就需要多个事件交互
        $timeout (-> $rootScope.$broadcast('issue:editor:show')), 1000

      scope.onKeyDown = (event)->
        return if event.keyCode isnt 13
        #处理回车
        text = _utils.trim(event.target.value)
        return if not text

        data =
          tag: attrs.tag
          title: text
          category_id: $stateParams.category_id
          version_id: $stateParams.version_id

        API.project(scope.project.id).issue().create(data).then (result)->
          NOTIFY.success "创建#{titleMap[attrs.tag]}成功"
          event.target.value = null
          #通知issue被创建
          scope.$emit 'issue:change', {status: 'new', tag: attrs.tag, id: result.id}
          #跳转
          gotoIssue result.id
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

  #任务标签的下拉列表
  .directive('issueTagDropdown', [->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-issue-tag-dropdown', _template
    link: (scope, element, attrs)->

  ])

  #issue列表
  .directive('issuePlainList', [->
    restrict: 'E'
    replace: true
#    scope: source: '@', title: '@'
    scope: title: '@', emptyMemo: '@'
    template: _utils.extractTemplate '#tmpl-issue-plain-list', _template
    link: (scope, element, attrs)->
#      scope.$watch 'source', ()->
#        return if not scope.source
#        scope.source = JSON.parse(scope.source)

      scope.emptyMemo = scope.emptyMemo || "#{scope.title}的任务为空"

      attrs.$observe('source', ->
        return if not attrs.source
        scope.source = JSON.parse(attrs.source)
      )
  ])