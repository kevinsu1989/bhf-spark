#git列表
'use strict'
define [
  '../ng-module'
  '../utils'
  '_'
  't!/views/global-all.html'
], (_module, _utils, _, _tmplGlobal) ->

  _module.directiveModule.directive('gitListEditor', ['NOTIFY', (NOTIFY)->
    restrict: 'E'
    replace: true
    scope: true
    template: _utils.extractTemplate '#tmpl-global-git-list', _tmplGlobal
    link: (scope, element, attrs)->
      #校验用户输入的正则表达式
      testExpr = new RegExp(attrs.expression)

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

        #检测用户输入是否合法
        return NOTIFY.error('您输入的内容不合法') if not testExpr.test(account)

        if _.indexOf(scope.gitAccounts, account) > -1
          bindDataForInput ''
          return
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
  ])