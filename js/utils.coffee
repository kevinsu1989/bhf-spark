define [

], ()->
  #去除前后的空格
  trim: (text)-> text and text.replace(/^\s+/, "" ).replace(/\s+$/, "")
  #格式化文本
  formatString: (text, args...)->
    return text if not text
    #如果第一个参数是数组，则直接使用这个数组
    args = args[0] if args.length is 1 and args[0] instanceof Array
    text.replace /\{(\d+)\}/g, (m, i) -> args[i]

  #提取text中包括规则的模板html，即包含在textarea中的
  extractTemplate: (expr, text)->
    $(text).find(expr).val()

  apis:
    [
      {
        "url": "mine",
        "methods": {
          "patch": false
        }
      },
      {
        "url": "session",
        "methods": {
          "put": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/attachment/:filename",
        "methods": {}
      },
      {
        "url": "project",
        "methods": {}
      },
      {
        "url": "project/:project_id/status",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/deploy",
        "methods": {
          "get": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "git/commit",
        "methods": {
          "get": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "commit/import/rss",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/git/tags",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/member",
        "methods": {}
      },
      {
        "url": "project/:project_id/git/commit",
        "methods": {
          "get": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/plan",
        "methods": {
          "get": false,
          "delete": false,
          "patch": false,
          "post": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/commit",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/assets",
        "methods": {
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/assets",
        "methods": {
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/commit",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/commit",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "assets/:project_id/:zipfile/unwind",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/issue",
        "methods": {
          "delete": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/report",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "report/issue",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/stat",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/report/weekly",
        "methods": {
          "post": false,
          "delete": false,
          "patch": false,
          "put": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/comment",
        "methods": {}
      },
      {
        "url": "project/:project_id/discussion",
        "methods": {
          "put": false,
          "post": false,
          "delete": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/status",
        "methods": {
          "get": false,
          "delete": false,
          "post": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/tag",
        "methods": {
          "get": false,
          "delete": false,
          "post": false,
          "patch": false
        }
      },
      {
        "url": "project/:project_id/issue/:issue_id/priority",
        "methods": {
          "get": false,
          "delete": false,
          "post": false
        }
      },
      {
        "url": "account/change-password",
        "methods": {
          "post": false,
          "delete": false,
          "get": false,
          "patch": false
        }
      },
      {
        "url": "member/role",
        "methods": {
          "post": false,
          "delete": false,
          "get": false,
          "patch": false
        }
      },
      {
        "url": "account/token",
        "methods": {
          "put": false,
          "delete": false,
          "get": false,
          "patch": false
        }
      },
      {
        "url": "member",
        "methods": {
          "put": false,
          "delete": false,
          "patch": false
        }
      },
      {
        "url": "member/mail",
        "methods": {
          "get": false,
          "put": false,
          "delete": false,
          "patch": false
        }
      },
      {
        "url": "account/profile",
        "methods": {
          "delete": false,
          "post": false,
          "patch": false
        }
      },
      {
        "url": "account/avatar/:member_id",
        "methods": {
          "put": false,
          "delete": false,
          "post": false,
          "patch": false
        }
      },
      {
        "url": "apis",
        "methods": {}
      }
    ]