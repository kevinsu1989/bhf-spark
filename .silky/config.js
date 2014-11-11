/*
    导出的配置文件
 */
module.exports = {
    //默认使用80端口，*nix下需要sudo
    port: 14422,
    //代理配置相关，兼容json-proxy的代理配置
    proxy: {
        forward: {
            //定义代理转发
//            "/api": "http://192.168.8.108:8001/api"
            "/api": "http://192.168.8.103:8002/api"
        }
    },
    //实时刷新
    livereload: {
        //实时刷新的环境，支持数组，如['development', 'production']
        env: [],
        //是否以amd的方式加载socket.io以及main.js
        amd: false
    },
    //路由
    routers: [
        {
            //无扩展名的访问，则直接跳到main
            path: /.*(\/[^\.]+(\/)?)$/i, to: '/main.html', next: false
        },
        {
            //登录页，暂用，应该和上面的正则合并
            path: /^\/login$/, to: '/main.html', next: false
        },
        {
            //首页
            path: /^(\/)$/, to: '/main.html', next: true
        }
    ],
    //替换掉文件名中的source
    "replaceSource": true,
    //build的配置
    build: {
        //构建的目标目录，命令行指定的优先
        output: "./build",
        //重命名
        rename: [
            {
                source: /source\.(js)$/i, target: '$1'
            }
        ],
        //是否压缩
        compress: {
            //压缩js，包括coffee
            js: false,
            //压缩css，包括less
            css: false,
            //压缩html
            html: false,
            //是否压缩internal的js
            internal: false
        },
        //将要复制的文件目录，直接复制到目标
        copy: ["images", "package", "fonts"],
        //将要编译处理的目录，如果存在less/coffee，则会直接编译
        compile: {
            //将template直接输出到目标目录下
            "template":{
                //保存到目标
                target: './',
                //要忽略的路径
                ignore: /module$/i
            },
            //编译js目录
            "js": {
                //不编译直接复制的文件
                copy: [/\.min\.js$/i, /^vendor/i]
            },
            //编译css目录
            "css": {
                //忽略目标目录
                ignore: /module$/i
            }
        }
    },
    //将要监控哪些文件目录，当监控中的内容被更改后，会触发客户端的自动更新事件
    watch: {
        //监控js目录，以js和coffee结尾的，将被监控
        "js": /(js|coffee)$/i,
        //监控less和css
        "css": /(css|less)$/i,
        //监控handlebars
        "template": /(html|hbs)$/ig
    }
}