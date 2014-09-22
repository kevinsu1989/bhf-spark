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
  .directive('gitListEditor', ->
    restrict: 'E'
    replace: true
    template: _utils.extractTemplate '#tmpl-global-git-list', _template
    link: (scope, element, attrs)->
      #允许存储的最大git账户数量
      maxCount =  +attrs.maxcount or 5
      #保存编辑状态
      isNowEditing = false

      #绑定git列表
      bindGitAccounts = (data)-> scope.gitAccounts = data

      #添加一条git账户数据
      addGitAccount = (account)->
        return if scope.gitAccounts.length >= maxCount
        scope.gitAccounts.push account

      #删除一个git账户
      deleteGitAccount = (index)->
        isNowEditing = false
        scope.gitAccounts.splice index, 1

      #编辑一个git账户
      editGitAccount = (account, index)-> scope.gitAccounts[index] = account

      #给input 赋值
      bindDataForInput = (value)-> element.find(':text').val value

      #初始化
      init = ()->
        scope.gitAccounts = []

      init()

      #回车 动作添加git账户
      scope.onKeypressAdd = (event)->
        return if event.keyCode isnt 13
        event.preventDefault()
        account = event.currentTarget.value
        return if /^(\s)*$/.test account
        addGitAccount account if isNowEditing is false
        editGitAccount account, isNowEditing if isNowEditing isnt false
        bindDataForInput ''
        isNowEditing = false

      scope.onClickRemove = (event, index)-> deleteGitAccount index

      scope.onClickEdit = (event, index, account)->
        isNowEditing = index
        bindDataForInput account
        return

      #监听事件绑定数据
      scope.$on 'member:profile:bind', (event, data)->
        event.preventDefault()
        bindGitAccounts data

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

