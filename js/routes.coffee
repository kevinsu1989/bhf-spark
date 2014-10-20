"use strict"
define [
  "ng"
  "app"
  'utils'
  't!/views/issue/issue-all.html'
  't!/views/member/member-all.html'
  't!/views/commit/commit-all.html'
  't!/views/assets/assets-all.html'
  't!/views/project/project-all.html'
], (_ng, _app, _utils, _tmplIssue, _tmplMember, _tmplCommit, _tmplAssets, _tmplProject) ->

  _app.config(($routeProvider, $locationProvider, $stateProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode true

    issueListView =
      template: _utils.extractTemplate('#tmpl-issue-list', _tmplIssue)
      controller: 'issueListController'

    $urlRouterProvider.otherwise('/');

    $stateProvider
    .state('home',
      url: '/'
      templateUrl: '/views/home.html'
      controller: 'homeController'
    )
    #登录
    .state('login',
      url: '/login?next'
      templateUrl: '/views/member/login.html'
      controller: 'loginController'

    )

    .state('project',
      url: '/project/:project_id'
      templateUrl: '/views/project/layout.html'
      controller: 'projectController'
    )

    .state('project.weekly-report',
      url: '/weekly-report'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-project-weekly-report-list', _tmplProject)
          controller: 'projectWeeklyReportListController'
        'details-panel': {}
    )

    .state('project.weekly-report-details',
      url: '/weekly-report/:week'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-project-weekly-report-list', _tmplProject)
          controller: 'projectWeeklyReportListController'
        'details-panel':
          template: _utils.extractTemplate('#tmpl-project-weekly-report-details', _tmplProject)
          controller: 'projectWeeklyReportDetailsController'
    )

    #issue列表
    .state('project.issue',
      url: '/issue'
      data: baseLink: '/issue/'
      views:
        'list-panel': issueListView
    )

    .state('project.issue-myself',
      url: '/issue/myself'
      views:
        'list-panel': issueListView
    )

    .state('project.issue-details',
      url: '/issue/:issue_id'
      views:
        'list-panel': issueListView
        'details-panel':
          templateUrl: '/views/issue/details.html'
          controller: 'issueDetailsController'
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

    .state('project.commit-details',
      url: '/commit/:commit_id?url'
      views:
        'details-panel':
          template: _utils.extractTemplate('#tmpl-commit-details', _tmplCommit)
          controller: 'commitDetailsController'
    )

    #讨论
    .state('project.discussion',
      url: '/discussion'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-discussion-list', _tmplIssue)
          controller: 'discussionListController'
    )

    #discussion
    .state('project.discussion-details',
      url: '/discussion/:issue_id'
      data: articleOnly: true
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-discussion-list', _tmplIssue)
          controller: 'discussionListController'
        'details-panel':
          templateUrl: '/views/issue/details.html'
          controller: 'issueDetailsController'
    )

    #标签
    .state('project.issue-category',
      url: '/category/:category_id/issue'
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-issue-list', _tmplIssue)
          controller: 'issueListController'
    )

    #素材
    .state('project.assets',
      url: '/assets'
      data: isTag: true
      views:
        'list-panel':
          template: _utils.extractTemplate('#tmpl-assets-list', _tmplAssets)
          controller: 'assetsListController'
    )
  )