#全局级的directive，和模块无关
'use strict'
define [
  './ng-module'
  './utils'
  '_'
  't!/views/global-all.html'
  'plugin/jquery.honey.simple-tab'
], (_module,_utils, _, _template) ->

  _module.directiveModule

  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer

      $menus.bind 'mouseleave', -> $menus.fadeOut()
      $self.bind 'click', -> $menus.fadeIn()

      attrs.$observe('selected', ->
        return if not scope.items
        selected = attrs.selected || -1
        $current = $menus.find("a[data-value='#{selected}']")
        $text.text $current.text()
      )

        #scope.$broadcast 'dropdown:selected', attrs.name, selected


      $menus.bind 'click', (e)->
        e.stopPropagation()
        $this = $(e.target)
        $parent = $this.closest('a')
        $menus.fadeOut()

        #如果没有有指定data-value，则不处理
        value = $parent.attr('data-value')
        return if not value

        $text.text $parent.text()
        scope.$broadcast 'dropdown:selected', attrs.name, value
  )

  #git的列表编辑器
  .directive('gitListEditor', ()->
    restrict: 'E'
    replace: true
    scope: true
    template: _utils.extractTemplate '#tmpl-global-git-list', _template
    link: (scope, element, attrs)->
      #允许存储的最大git账户数量
      maxCount =  parseInt attrs.maxCount
      #保存编辑状态 -1表示非编辑状态
      nowEditingIndex = -1

      #向上冒泡数据
      doBroadcastData = ()->
        scope.$emit 'gitList:update', attrs.name, scope.gitAccounts

      #添加一条git账户数据
      addGitAccount = (account)->
        return if scope.gitAccounts.length >= maxCount
        scope.gitAccounts.push account

      #给input 赋值
      bindDataForInput = (value)-> element.find("input").val value

      #初始化绑定
      attrs.$observe('gits', (data)->
        return if not data? or data is ''
        scope.gitAccounts = JSON.parse data
      )

      #回车 动作添加git账户
      scope.onKeypressAdd = (event)->
        return if event.keyCode isnt 13
        event.preventDefault()
        account = _utils.trim event.currentTarget.value
        return if account is ''
        if nowEditingIndex is -1
          addGitAccount account
        else
          scope.gitAccounts[nowEditingIndex] = account
        bindDataForInput ''
        nowEditingIndex = -1
        doBroadcastData()
        return

      scope.onClickRemove = (event, index)->
        scope.gitAccounts.splice index, 1
        nowEditingIndex = -1
        doBroadcastData()
        return

      scope.onClickEdit = (event, index, account)->
        nowEditingIndex = index
        bindDataForInput account
        return
  )

  #tab的directive
  .directive('simpleTab', ->
    restrict: 'A'
    replace: false
    link: (scope, element, attrs)->
      $o = $(element).simpleTab()
      attrs.$observe 'activeIndex', ()->
        $o.simpleTab 'change', parseInt(attrs.activeIndex)
  )

