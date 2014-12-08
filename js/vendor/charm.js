(function(){var t=[].slice;!function(){var e,r,n,o;return e=function(){function t(t,e){this.parent=t,this.segmentModel=e,this.params=[],this._updateProperties(),this._addMethods()}return t.prototype._addMethod=function(t,e){var r;return r=this,this[e]=function(e,n){return"function"==typeof e&&(n=e,e={}),r._doAction(t,e,n)}},t.prototype._addMethods=function(){var t,e,r,n,o;e={post:"create",put:"update",patch:"patch","delete":"delete",get:"retrieve",jsonp:"jsonp"},n=this.segmentModel.options.methods||e,o=[];for(t in n)r=n[t],o.push(this._addMethod(t,r));return o},t.prototype._addPlainParam=function(t,e){var r;return(r=this.segmentModel.placeholders[e])?this.params[e]={key:r.key,value:String(t)}:void 0},t.prototype._addObjectParam=function(t){var e,r,n,o,i,s,a,u,p;p=[];for(o in t){for(i=t[o],e=-1,u=this.segmentModel.placeholders,r=s=0,a=u.length;a>s;r=++s)if(n=u[r],n.key===o){e=r;break}p.push(this._addPlainParam(i,e))}return p},t.prototype._addParams=function(t){var e,r,n,o,i,s;for(s=[],e=n=0,o=t.length;o>n;e=++n)r=t[e],s.push("string"==(i=typeof r)||"number"===i?this._addPlainParam(r,e):this._addObjectParam(r));return s},t.prototype._currentToString=function(){var t,e,r,n,o;for(e=this.segmentModel.name,o=this.params,r=0,n=o.length;n>r;r++)t=o[r],t.value&&(e+="/"+t.value);return e},t.prototype._extractMethodName=function(t){return this.segmentModel.options.rawMethodName?t:t=t.replace(/[\-](\w)/,function(t,e){return e.toUpperCase()})},t.prototype._updateProperties=function(){var e,r,n,o,i,s;for(i=this.segmentModel.children,s=[],n=0,o=i.length;o>n;n++)e=i[n],r=this._extractMethodName(e.name),this[r]||s.push(this[r]=t.create(this,e));return s},t.prototype._doAction=function(t,e,r){var n,o,i,s;return i=this.segmentModel.options.promise,n=this.segmentModel.options.ajax,s=this.toString(),i?(o=i.defer(),n(s,t,e,function(t){return o.resolve(t)},function(t){return o.reject(t)}),o.promise):n(s,t,e,r)},t.prototype.parse=function(t){return this.segmentModel.parse(t),this._updateProperties()},t.prototype.toString=function(t){var e,r,n;return this.parent?(e=this.segmentModel.options,r=(null!=(n=this.parent)?n.toString(!0):void 0)||e.prefix||"",r+="/"+this._currentToString(),!t&&e.suffix&&(r+=e.suffix),r):""},t}(),e.create=function(r,n){return function(){var o,i;return o=1<=arguments.length?t.call(arguments,0):[],i=new e(r,n),i._addParams(o),i}},r=function(){function t(t,e,r){this.parent=t,this.name=e,this.options=r,this.children=[],this.placeholders=[]}return t.prototype.parseUrl=function(t){var e,r,n,o,i,s,a;for(e=this,n=t.url||t,s=n.split("/"),a=[],o=0,i=s.length;i>o;o++)r=s[o],a.push(e=e.addChild(r));return a},t.prototype.parse=function(t){var e,r,n,o;for(t instanceof Array||(t=[t]),o=[],r=0,n=t.length;n>r;r++)e=t[r],o.push(this.parseUrl(e));return o},t.prototype.setPlaceholders=function(t){return"object"==typeof t?this.addPlaceholders(t):void 0},t.prototype.addPlaceholder=function(t){return this.placeholders.push({key:t})},t.prototype.addChild=function(t){var e,r,n,o;if(/^:.+/.test(t))return this.addPlaceholder(t.substr(1)),this;for(o=this.children,r=0,n=o.length;n>r;r++)if(e=o[r],e.name===t)return e;return this.createSegmentModel(t)},t.prototype.createSegmentModel=function(e){var r;return r=new t(this,e),r.options=this.options,this.children.push(r),r},t}(),o=function(t,e,r,n){var o;return("undefined"!=typeof $&&null!==$?$.ajax:void 0)?(o="jsonp"===e?"JSONP":"JSON","jsonp"===e&&(e="GET"),$.ajax(t,{type:e,data:r,dataType:o,success:function(t){return"function"==typeof n?n(t):void 0}})):console.error("请设置options.ajax参数或引用jQuery")},n=function(t){var n,i;return t=t||{},t.ajax=t.ajax||o,i=new r(null,null,t),n=new e(null,i)},"function"==typeof define?define([],function(){return n}):"object"==typeof exports?module.exports=n:window.charm=n}()}).call(this);