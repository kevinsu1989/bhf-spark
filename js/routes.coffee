"use strict"
define [
  "ng"
  "app"
], (_ng, _app) ->
  _app.config ($routeProvider, $locationProvider, $stateProvider) ->
    $locationProvider.html5Mode true

    $stateProvider
      .state('project',
        url: '/project/:project_id'
        templateUrl: '/views/project/layout.html'
        controller: 'projectController'
    )
    .state('project.issue',
      url: '/issue/:issue_id'
      views:
        'issue-details':
          templateUrl: '/views/issue/details.html'
          controller: 'issueDetailsController'
    )

    return;
    #访问某个项目
    $routeProvider.when("/project/:project_id",
      templateUrl: "/views/project/layout.html"
      controller: "projectController"
    )

    #issue
    .when('/project/:project_id/issue/:issue_id',
      templateUrl: "/views/project/layout.html"
      controller: "projectController"
    )

    #项目的成员管理
    .when('/project/:project_id/member',
      templateUrl: "/views/project/layout-member.html"
      controller: "projectMemberController"
    )

    #项目的commit
    .when('/project/:project_id/commit',
      templateUrl: "/views/project/layout-commit.html"
      controller: "projectCommitController"
    )

    #项目的讨论列表
    .when('/project/:project_id/discussion',
      templateUrl: "/views/project/layout-discussion.html"
      controller: "projectDiscussionController"
    )

    #项目的版本
    .when('/project/:project_id/version',
      templateUrl: "/views/project/layout-version.html"
      controller: "projectVersionController"
    )

    #项目的统计
    .when('/project/:project_id/stat',
      templateUrl: "/views/project/layout-stat.html"
      controller: "projectStatController"
    )

    $routeProvider.otherwise redirectTo: "/"
