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
  't!/views/report/report-all.html'
  't!/views/global-all.html'
], (_ng, _app, _utils, _tmplIssue, _tmplMember,
    _tmplCommit, _tmplAssets, _tmplProject, _tmplReport, _tmplGlobal) ->

  _app.config(($routeProvider, $locationProvider, $stateProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode true

    blankDetailsView =
      template: _utils.extractTemplate '#tmpl-global-blank-page', _tmplGlobal
      controller: ->

    #issue
    issueViews =
      'listPanel':
        template: _utils.extractTemplate('#tmpl-issue-list', _tmplIssue)
        controller: 'issueListController'
      'detailsPanel@project':
        templateUrl: '/views/issue/details.html'
        controller: 'issueDetailsController'

    issueListOnly =
      'listPanel@project': issueViews.listPanel
      detailsPanel: blankDetailsView

    documentListOnly =
      'listPanel@project':
        template: _utils.extractTemplate '#tmpl-document-list', _tmplIssue
        controller: 'documentListController'
      detailsPanel: blankDetailsView

    documentViews =
      listPanel: documentListOnly['listPanel@project']
      'detailsPanel@project': issueViews['detailsPanel@project']

    #讨论
    discussionViews =
      listPanel:
        template: _utils.extractTemplate('#tmpl-discussion-list', _tmplIssue)
        controller: 'discussionListController'
      'detailsPanel@project':
        templateUrl: '/views/issue/details.html'
        controller: 'issueDetailsController'

    discussionListOnly =
      listPanel: discussionViews.listPanel
      detailsPanel: blankDetailsView


    weeklyReportListOnly =
      listPanel:
        template: _utils.extractTemplate('#tmpl-report-weekly-list', _tmplReport)
        controller: 'weeklyReportListController'
      detailsPanel: blankDetailsView

    weeklyReportViews =
      listPanel: weeklyReportListOnly.listPanel
      'detailsPanel@project':
        template: _utils.extractTemplate('#tmpl-report-weekly-details', _tmplReport)
        controller: 'reportWeeklyDetailsController'

    memberListOnly =
      'listPanel@project':
        template: _utils.extractTemplate('#tmpl-project-member-list', _tmplMember)
      detailsPanel: blankDetailsView

    commitListOnly =
      'listPanel@project':
        template: _utils.extractTemplate('#tmpl-commit-list', _tmplCommit)
        controller: 'commitListController'
      detailsPanel: blankDetailsView

    assetsListOnly =
      listPanel:
        template: _utils.extractTemplate('#tmpl-assets-list', _tmplAssets)
        controller: 'assetsListController'
      detailsPanel: blankDetailsView

    assetsPreviewerViews =
      listPanel: assetsListOnly.listPanel
      'detailsPanel@project':
        template: _utils.extractTemplate('#tmpl-assets-previewer', _tmplAssets)
        controller: 'assetsPreviewerController'

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
      views: issueListOnly
    ).state('project.issue.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    .state('project.version',
      url: '/version/:version_id'
      abstract: true
    )

    #分类->issue
    .state('project.issue_category',
      url: '/category/:category_id/issue'
      views:
        listPanel: issueViews.listPanel
    ).state('project.issue_category.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    #版本->分类->issue
    .state('project.version_category_issue',
      url: '/version/:version_id/category/:category_id/issue'
      views: issueListOnly
    ).state('project.version_category_issue.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    #获取版本下的所有issue，但不考虑分类
    .state('project.version_issue',
      url: '/version/:version_id/issue'
      views: issueListOnly
    ).state('project.version_issue.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    #用户自己的issue
    .state('project.my_issue',
      url: '/issue/{myself:myself}'
      views: issueListOnly
    ).state('project.my_issue.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    #在指定版本下，用户自己的issue
    .state('project.version.my_issue',
      url: '/issue/{myself:myself}'
      views: issueListOnly
    ).state('project.version.my_issue.details',
      url: '/{issue_id:\\d+}'
      views: issueViews
    )

    #=====================================周报相关=======================================
    #周报
    .state('project.weekly_report',
      url: '/weekly-report'
      views: weeklyReportListOnly
    )

    .state('project.weekly_report.details',
      url: '/{start_time}~{end_time}'
      views: weeklyReportViews
    )

    .state('project.version_weekly_report',
      url: '/version/:version_id/weekly-report'
      views: weeklyReportListOnly
    )

    .state('project.version_weekly_report.details',
      url: '/{start_time}~{end_time}'
      views: weeklyReportViews
    )

#    #项目版本列表
#    .state('project.version',
#      url: '/version'
#      views: 'list-panel': {}
#    )


    #成员
    .state('project.member',
      url: '/member'
      views: memberListOnly
    ).state('project.version.member',
      url: '/member'
      views: memberListOnly
    )

    #commit
    .state('project.commit',
      url: '/commit'
      views: commitListOnly
    ).state('project.version.commit',
      url: '/commit'
      views: commitListOnly
    )

    .state('project.version.commit.details',
      url: '/:commit_id?url'
      views:
        'detailsPanel@project':
          template: _utils.extractTemplate('#tmpl-commit-details', _tmplCommit)
          controller: 'commitDetailsController'
    )

    #====================================讨论相关=======================================
    #讨论
    .state('project.discussion',
      url: '/discussion'
      views: discussionListOnly
    ).state('project.discussion.details',
      url: '/{issue_id:\\d+}'
      data: articleOnly: true
      views: discussionViews
    )

    .state('project.version_discussion',
      url: '/version/:version_id/discussion'
      views: discussionListOnly
    ).state('project.version_discussion.details',
      url: '/{issue_id:\\d+}'
      data: articleOnly: true
      views: discussionViews
    )

    #====================================文档=======================================

    .state('project.document',
      url: '/document'
      views: documentListOnly
    ).state('project.version.document',
      url: '/document'
      views: documentListOnly
    ).state('project.version.document.details',
      url: '/:issue_id'
      data: articleOnly: true
      views: documentViews
    ).state('project.document.details',
      url: '/:issue_id'
      data: articleOnly: true
      views: documentViews
    )


    #素材
    .state('project.assets',
      url: '/assets'
      views: assetsListOnly
    ).state('project.version_assets',
      url: '/version/:version_id/assets'
      views: assetsListOnly
    ).state('project.version_assets.previewer'
      url: '/previewer/:asset_id'
      views: assetsPreviewerViews
    ).state('project.assets.previewer'
      url: '/previewer/:asset_id'
      views: assetsPreviewerViews
    )
  )