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

    issueDetailsView =
      templateUrl: '/views/issue/details.html'
      controller: 'issueDetailsController'

    discussionListView =
      template: _utils.extractTemplate('#tmpl-discussion-list', _tmplIssue)
      controller: 'discussionListController'

    discussionDetailsView =
      templateUrl: '/views/issue/details.html'
      controller: 'issueDetailsController'
#    $urlRouterProvider.otherwise('/');

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
      abstract: true
      url: '/project/:project_id'
      templateUrl: '/views/project/layout.html'
      controller: 'projectController'
    )

    #=====================================ISSUE相关=======================================
    #issue列表
    .state('project.issue',
      url: '/issue'
      views:
        'list-panel': issueListView
    ).state('project.issue.details',
      url: '/{issue_id:\\d+}(\\d+)'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
    )

    #分类->issue
    .state('project.issue_category',
      url: '/category/:category_id/issue'
      views:
        'list-panel': issueListView
    ).state('project.issue_category.details',
      url: '/{issue_id:\\d+}'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
    )

    #版本->分类->issue
    .state('project.version_category_issue',
      url: '/version/:version_id/category/:category_id/issue'
      views:
        'list-panel': issueListView
    ).state('project.version_category_issue.details',
      url: '/{issue_id:\\d+}'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
    )

    #获取版本下的所有issue，但不考虑分类
    .state('project.version_issue',
      url: '/version/:version_id/issue'
      views: 'list-panel': issueListView
    ).state('project.version_issue.details',
      url: '/{issue_id:\\d+}(\\d+)'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
    )

    #用户自己的issue
    .state('project.my_issue',
      url: '/issue/{myself:myself}'
      views:
        'list-panel': issueListView
        'details-panel': {}
    ).state('project.my_issue.details',
      url: '/{issue_id:\\d+}(\\d+)'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
    )

    #在指定版本下，用户自己的issue
    .state('project.version_my_issue',
      url: '/version/:version_id/issue/{myself:myself}'
      views:
        'list-panel': issueListView
        'details-panel': {}
    ).state('project.version_my_issue.details',
      url: '/{issue_id:\\d+}(\\d+)'
      views:
        'list-panel': issueListView
        'details-panel@project': issueDetailsView
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



    #项目版本列表
    .state('project.version',
      url: '/version'
      views: 'list-panel': {}
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
        'list-panel': discussionListView
    ).state('project.discussion.details',
      url: '/{issue_id:\\d+}'
      data: articleOnly: true
      views:
        'list-panel': discussionListView
        'details-panel@project': discussionDetailsView
    )

    .state('project.version_discussion',
      url: '/version/:version_id/discussion'
      views:
        'list-panel': discussionListView
    ).state('project.version_discussion.details',
      url: '/{issue_id:\\d+}'
      data: articleOnly: true
      views:
        'list-panel': discussionListView
        'details-panel@project': discussionDetailsView
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