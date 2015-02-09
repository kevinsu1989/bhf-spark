define [
  '../ng-module'
  '../utils'
  't!../../views/member/authority.html'
], (_module, _utils, _template) ->

  _module.directiveModule
  .directive('signIn', ['$location', '$state', 'API', ($location, $state, API)->
    restrict: 'E'
    replace: true
    scope: true
    template: _utils.extractTemplate '#tmpl-member-signin', _template
    link: (scope, element, attr)->
      scope.model = {}

      scope.onSubmitSignIn = ()->
        return scope.error = '请输入您的E-mail或者用户名' if not scope.model.account
        return scope.error = '请输入您的密码' if not scope.model.password

        API.session().create(scope.model).then((result)->
          #跳到首页
          $location.path $state.params.next || '/'
        )

      #点击忘记密码
      scope.onClickResetPassword = ->
        return alert('请输入您的帐号或者E-mail') if not scope.model.account
        API.account().resetPassword().retrieve(account: scope.model.account).then ->
          alert("您的密码已经被重置，请检查您的邮箱\n如果没有找到，请检查垃圾箱")
  ])
  #注册
  .directive('signUp', ['$stateParams', 'API', 'NOTIFY', ($stateParams, API, NOTIFY)->
    restrict: 'E'
    replace: true
    scope: true
    template: _utils.extractTemplate '#tmpl-member-signup', _template
    link: (scope, element, attr)->
      model = scope.model =
        token: $stateParams.token
#        realname: '易晓峰'
#        email: 'conis.yi@gmail.com'
#        password: 'password'
#        confirmPassword: 'password'

      #注册
      scope.onClickSignUp = ->
        return scope.error = '请输入您的真实姓名' if not scope.model.realname
        return scope.error = '密码没有输入或者密码太短' if not scope.model.password
        return scope.error = '您两次的密码输入不一致' if scope.model.password isnt scope.model.confirmPassword

        API.member().create(model).then ()->
          NOTIFY.success "恭喜您注册成功，请登录"
          scope.onClickSwitchPanel('0px')

  ])

  .directive('authorityPanel', ['$stateParams', ($stateParams)->
    restrict: 'A'
    replace: true
    link: (scope, element, attrs)->

      scope.onClickSwitchPanel = (offset)->
        element.find('.sign-up').css('visibility', 'visible')
        element.css 'margin-left', offset
        return

      scope.onClickSwitchPanel('-350px') if $stateParams.token
  ])

  .directive('inviteMember', ['$location', '$stateParams', 'NOTIFY', 'API', 'HOST',
  ($location, $stateParams, NOTIFY, API, HOST)->
    restrict: 'E'
    replace: true
    scope: {}
    template: _utils.extractTemplate '#tmpl-member-invite', _template
    link: (scope, element, attrs)->
      scope.host = HOST
      inviteAPI = API.project($stateParams.project_id).member().invite()

      loadInvitedMember = (cb)->
        inviteAPI.retrieve().then (result)->
          scope.invitedMember = result
          cb?()

      #生成邀请码
      scope.onClickInvite = ->
        inviteAPI.create().then ->
          NOTIFY.success '您的邀请码已经成功创建，请将链接发给要邀请的同事'
          loadInvitedMember()

      scope.$on 'member:invite:show', ->
        loadInvitedMember -> element.modal showClose: false

#      scope.onFocusInput = (event)-> event.target.select()
  ])