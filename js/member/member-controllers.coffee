define [
  '../ng-module'
  '../utils'
], (_module,_utils) ->

  _module.controllerModule.
  #项目成员列表
  controller('projectMemberListController', ($scope, $stateParams, API)->

  )

  .controller('loginController', ($scope, $state, $location, API)->
    $scope.onClickSubmit = ()->
      return $scope.error = '请输入您的E-mail或者用户名' if not $scope.account
      return $scope.error = '请输入您的密码' if not $scope.password

      data =
        account: $scope.account
        password: $scope.password
        remember: $scope.remember

      API.post('session', data).then((result)->
        #暂时跳到这个项目
        $location.path $state.params.next || '/project/1/issue'
      )
  )