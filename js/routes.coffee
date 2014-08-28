"use strict"
define [
  "ng"
  "app"
], (_ng, _app) ->
  _app.config ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode true

    #访问某个项目
    $routeProvider.when("/project/:project_id",
      templateUrl: "/views/project/layout.html"
      controller: "projectController"
    )

    .when('/project/:project_id/issue/:issue_id',
      templateUrl: "/views/project/layout.html"
      controller: "projectController"
    )

    $routeProvider.otherwise redirectTo: "/"
