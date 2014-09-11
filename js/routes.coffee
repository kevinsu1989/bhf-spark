"use strict"
define [
  "ng"
  "app"
  'utils'
  't!/views/issue/all.html'
  't!/views/member/all.html'
  't!/views/commit/all.html'
], (_ng, _app, _utils, _tmplIssue, _tmplMember, _tmplCommit) ->
  _app.config ($routeProvider, $locationProvider, $stateProvider) ->
    $locationProvider.html5Mode true

    $stateProvider
    .state('project',
      url: '/project/:project_id'
      templateUrl: '/views/project/layout.html'
      controller: 'projectController'
    )

    #成员
    .state('project.member',
      url: '/member'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-project-member-list', _tmplMember)
        'details-panel': {}
    )

    #commit
    .state('project.commit',
      url: '/commit'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-commit-list', _tmplCommit)
          controller: 'commitListController'
    )

    .state('project.commit.details',
      url: '/:commit_id?url'
      views:
        'details-panel':
          template: _utils.extractTemplate('#tmpl-commit-details', _tmplCommit)
          controller: -> console.log arguments
    )

    #讨论
    .state('project.discussion',
      url: '/discussion'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-discussion-list', _tmplIssue)
          controller: 'discussionListController'
    )

    #issue列表
    .state('project.issue',
      url: '/issue'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-issue-list', _tmplIssue)
          controller: 'issueListController'
        'details-panel': {}
    )

    #标签
    .state('project.issue.tag',
      url: '/tag/:tag'
      data: isTag: true
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-issue-list', _tmplIssue)
          controller: 'issueListController'
    )

    .state('project.issue.details',
      url: '/:issue_id'
      views:
        'details-panel':
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
