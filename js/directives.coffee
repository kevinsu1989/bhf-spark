#全局级的directive，和模块无关
'use strict'
define [
  './ng-module'
  './utils'
  '_'
  't!/views/global-all.html'
  't!/views/project/project-all.html'
  'pkg/webuploader/webuploader.html5only'
  'pkg/datetime/datetimepicker'
  'plugin/jquery.honey.simple-tab'
], (_module, _utils, _, _template, _directiveTmp, _WebUploader) ->
  _module.directiveModule

  .directive('dropdown', ()->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->
      $self = $(element)
      $menus = $self.find 'div.dropdown'
      $text = $self.find attrs.textContainer

      $menus.bind 'mouseleave', -> $menus.fadeOut()
      $self.bind 'click', (e)->
        $menus.fadeIn()
        e.stopPropagation()

        $('body').one 'click', -> $menus.fadeOut()

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
        scope.$emit 'dropdown:selected', attrs.name, value

  )
  #日期选择控件
  .directive('datetimePicker', ()->
    restrict: 'AC'
    link: (scope, element, attrs)->
      dateOpt =
        format: 'yyyy-MM-dd'
        startView: 2
        minView: 2

      timeOpt =
        format: 'hh:mm:ss'
        startView: 1
        minView: 0
        maxView: 1

      dateTimeOpt =
        format: 'yyyy-MM-dd HH:mm:ss'
        startView: 2

      name = attrs.name
      type = attrs.type
      formart = attrs.formart

      #判断类型
      switch type
        when 'time' then dateOpt = timeOpt
        when 'datetime'then dateOpt = dateTimeOpt

      #设定默认值
      dateOpt.showMeridian = true
      dateOpt.autoclose = true
      if formart then dateOpt.formart = formart

      $this = $(element);
      $this.datetimepicker(dateOpt)
      $this.on 'changeDate', (ev)->
        scope.$emit 'datetime:change', name, ev.date.valueOf()
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
  )

  #tab的directive
  .directive('simpleTab', ()->
    restrict: 'A'
    replace: false
    link: (scope, element, attrs)->
      $o = $(element).simpleTab()
      attrs.$observe 'activeIndex', ()->
        $o.simpleTab 'change', parseInt(attrs.activeIndex)
  )

  #文件上传组件
  .factory('webFileUploadService',  ()->
    option =
      server : ""
      # 选择文件的按钮
      pick:
        id   : '#picker'
        multiple  : true
      auto:true
    #初始化 WebUploader
    webUploaderInit = (opt,uploaderWarp)->
      option = angular.extend option, opt
      option.pick.id = uploaderWarp
      uploader = _WebUploader.create option
      return uploader

    return webUploaderInit: webUploaderInit
  )
