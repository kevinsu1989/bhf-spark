!function(e){"use strict";var t=e.HTMLCanvasElement&&e.HTMLCanvasElement.prototype,n=e.Blob&&function(){try{return Boolean(new Blob)}catch(e){return!1}}(),a=n&&e.Uint8Array&&function(){try{return 100===new Blob([new Uint8Array(100)]).size}catch(e){return!1}}(),i=e.BlobBuilder||e.WebKitBlobBuilder||e.MozBlobBuilder||e.MSBlobBuilder,r=(n||i)&&e.atob&&e.ArrayBuffer&&e.Uint8Array&&function(e){var t,r,o,s,l,u;for(t=e.split(",")[0].indexOf("base64")>=0?atob(e.split(",")[1]):decodeURIComponent(e.split(",")[1]),r=new ArrayBuffer(t.length),o=new Uint8Array(r),s=0;s<t.length;s+=1)o[s]=t.charCodeAt(s);return l=e.split(",")[0].split(":")[1].split(";")[0],n?new Blob([a?o:r],{type:l}):(u=new i,u.append(r),u.getBlob(l))};e.HTMLCanvasElement&&!t.toBlob&&(t.mozGetAsFile?t.toBlob=function(e,n,a){e(a&&t.toDataURL&&r?r(this.toDataURL(n,a)):this.mozGetAsFile("blob",n))}:t.toDataURL&&r&&(t.toBlob=function(e,t,n){e(r(this.toDataURL(t,n)))})),e.dataURLtoBlob=r}(window),function(e,t){"use strict";function n(e,t,n,a,i){var r={type:n.type||n,target:e,result:a};X(r,i),t(r)}function a(e){return b&&!!b.prototype["readAs"+e]}function i(e,i,r,o){if(V.isBlob(e)&&a(r)){var s=new b;W(s,H,function u(t){var a=t.type;"progress"==a?n(e,i,t,t.target.result,{loaded:t.loaded,total:t.total}):"loadend"==a?(G(s,H,u),s=null):n(e,i,t,t.target.result)});try{o?s["readAs"+r](e,o):s["readAs"+r](e)}catch(l){n(e,i,"error",t,{error:l.toString()})}}else n(e,i,"error",t,{error:"filreader_not_support_"+r})}function r(e,t){if(!e.type&&e.size%4096===0&&e.size<=102400)if(b)try{var n=new b;J(n,H,function(e){var a="error"!=e.type;t(a),a&&n.abort()}),n.readAsDataURL(e)}catch(a){t(!1)}else t(null);else t(!0)}function o(e){var t;return e.getAsEntry?t=e.getAsEntry():e.webkitGetAsEntry&&(t=e.webkitGetAsEntry()),t}function s(e,t){if(e)if(e.isFile)e.file(function(n){n.fullPath=e.fullPath,t(!1,[n])},function(e){t("FileError.code: "+e.code)});else if(e.isDirectory){var n=e.createReader(),a=[];n.readEntries(function(e){V.afor(e,function(e,n){s(n,function(n,i){n?V.log(n):a=a.concat(i),e?e():t(!1,a)})})},function(e){t("directory_reader: "+e)})}else s(o(e),t);else t("invalid entry")}function l(e){var t={};return q(e,function(e,n){e&&"object"==typeof e&&void 0===e.nodeType&&(e=X({},e)),t[n]=e}),t}function u(e){return L.test(e&&e.tagName)}function c(e){return(e.originalEvent||e||"").dataTransfer||{}}function f(e){var t;for(t in e)if(e.hasOwnProperty(t)&&!(e[t]instanceof Object||"overlay"===t||"filter"===t))return!0;return!1}var d=1,p=function(){},h=e.document,m=h.doctype||{},g=e.navigator.userAgent,v=e.createObjectURL&&e||e.URL&&URL.revokeObjectURL&&URL||e.webkitURL&&webkitURL,y=e.Blob,w=e.File,b=e.FileReader,x=e.FormData,A=e.XMLHttpRequest,F=e.jQuery,R=!(!(w&&b&&(e.Uint8Array||x||A.prototype.sendAsBinary))||/safari\//i.test(g)&&!/chrome\//i.test(g)&&/windows/i.test(g)),T=R&&"withCredentials"in new A,I=R&&!!y&&!!(y.prototype.webkitSlice||y.prototype.mozSlice||y.prototype.slice),C=e.dataURLtoBlob,_=/img/i,D=/canvas/i,U=/img|canvas/i,L=/input/i,E=/^data:[^,]+,/,B={}.toString,P=e.Math,S=function(t){return t=new e.Number(P.pow(1024,t)),t.from=function(e){return P.round(e*this)},t},k={},z=[],H="abort progress error load loadend",M="status statusText readyState response responseXML responseText responseBody".split(" "),N="currentTarget",j="preventDefault",O=function(e){return e&&"length"in e},q=function(e,t,n){if(e)if(O(e))for(var a=0,i=e.length;i>a;a++)a in e&&t.call(n,e[a],a,e);else for(var r in e)e.hasOwnProperty(r)&&t.call(n,e[r],r,e)},X=function(e){for(var t=arguments,n=1,a=function(t,n){e[n]=t};n<t.length;n++)q(t[n],a);return e},W=function(e,t,n){if(e){var a=V.uid(e);k[a]||(k[a]={});var i=b&&e&&e instanceof b;q(t.split(/\s+/),function(t){F&&!i?F.event.add(e,t,n):(k[a][t]||(k[a][t]=[]),k[a][t].push(n),e.addEventListener?e.addEventListener(t,n,!1):e.attachEvent?e.attachEvent("on"+t,n):e["on"+t]=n)})}},G=function(e,t,n){if(e){var a=V.uid(e),i=k[a]||{},r=b&&e&&e instanceof b;q(t.split(/\s+/),function(t){if(F&&!r)F.event.remove(e,t,n);else{for(var a=i[t]||[],o=a.length;o--;)if(a[o]===n){a.splice(o,1);break}e.addEventListener?e.removeEventListener(t,n,!1):e.detachEvent?e.detachEvent("on"+t,n):e["on"+t]=null}})}},J=function(e,t,n){W(e,t,function a(i){G(e,t,a),n(i)})},K=function(t){return t.target||(t.target=e.event&&e.event.srcElement||h),3===t.target.nodeType&&(t.target=t.target.parentNode),t},Q=function(e){var t=h.createElement("input");return t.setAttribute("type","file"),e in t},V={version:"2.0.9",cors:!1,html5:!0,media:!1,formData:!0,multiPassResize:!0,debug:!1,pingUrl:!1,multiFlash:!1,flashAbortTimeout:0,withCredentials:!0,staticPath:"./dist/",flashUrl:0,flashImageUrl:0,postNameConcat:function(e,t){return e+(null!=t?"["+t+"]":"")},ext2mime:{jpg:"image/jpeg",tif:"image/tiff",txt:"text/plain"},accept:{"image/*":"art bm bmp dwg dxf cbr cbz fif fpx gif ico iefs jfif jpe jpeg jpg jps jut mcf nap nif pbm pcx pgm pict pm png pnm qif qtif ras rast rf rp svf tga tif tiff xbm xbm xpm xwd","audio/*":"m4a flac aac rm mpa wav wma ogg mp3 mp2 m3u mod amf dmf dsm far gdm imf it m15 med okt s3m stm sfx ult uni xm sid ac3 dts cue aif aiff wpl ape mac mpc mpp shn wv nsf spc gym adplug adx dsp adp ymf ast afc hps xs","video/*":"m4v 3gp nsv ts ty strm rm rmvb m3u ifo mov qt divx xvid bivx vob nrg img iso pva wmv asf asx ogm m2v avi bin dat dvr-ms mpg mpeg mp4 mkv avc vp3 svq3 nuv viv dv fli flv wpl"},uploadRetry:0,networkDownRetryTimeout:5e3,chunkSize:0,chunkUploadRetry:0,chunkNetworkDownRetryTimeout:2e3,KB:S(1),MB:S(2),GB:S(3),TB:S(4),EMPTY_PNG:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQIW2NkAAIAAAoAAggA9GkAAAAASUVORK5CYII=",expando:"fileapi"+(new Date).getTime(),uid:function(e){return e?e[V.expando]=e[V.expando]||V.uid():(++d,V.expando+d)},log:function(){V.debug&&e.console&&console.log&&(console.log.apply?console.log.apply(console,arguments):console.log([].join.call(arguments," ")))},newImage:function(e,t){var n=h.createElement("img");return t&&V.event.one(n,"error load",function(e){t("error"==e.type,n),n=null}),n.src=e,n},getXHR:function(){var t;if(A)t=new A;else if(e.ActiveXObject)try{t=new ActiveXObject("MSXML2.XMLHttp.3.0")}catch(n){t=new ActiveXObject("Microsoft.XMLHTTP")}return t},isArray:O,support:{dnd:T&&"ondrop"in h.createElement("div"),cors:T,html5:R,chunked:I,dataURI:!0,accept:Q("accept"),multiple:Q("multiple")},event:{on:W,off:G,one:J,fix:K},throttle:function(t,n){var a,i;return function(){i=arguments,a||(t.apply(e,i),a=setTimeout(function(){a=0,t.apply(e,i)},n))}},F:function(){},parseJSON:function(t){var n;return n=e.JSON&&JSON.parse?JSON.parse(t):new Function("return ("+t.replace(/([\r\n])/g,"\\$1")+");")()},trim:function(e){return e=String(e),e.trim?e.trim():e.replace(/^\s+|\s+$/g,"")},defer:function(){var e,n,a=[],i={resolve:function(t,r){for(i.resolve=p,n=t||!1,e=r;r=a.shift();)r(n,e)},then:function(i){n!==t?i(n,e):a.push(i)}};return i},queue:function(e){var t=0,n=0,a=!1,i=!1,r={inc:function(){n++},next:function(){t++,setTimeout(r.check,0)},check:function(){t>=n&&!a&&r.end()},isFail:function(){return a},fail:function(){!a&&e(a=!0)},end:function(){i||(i=!0,e())}};return r},each:q,afor:function(e,t){var n=0,a=e.length;O(e)&&a--?!function i(){t(a!=n&&i,e[n],n++)}():t(!1)},extend:X,isFile:function(e){return"[object File]"===B.call(e)},isBlob:function(e){return this.isFile(e)||"[object Blob]"===B.call(e)},isCanvas:function(e){return e&&D.test(e.nodeName)},getFilesFilter:function(e){return e="string"==typeof e?e:e.getAttribute&&e.getAttribute("accept")||"",e?new RegExp("("+e.replace(/\./g,"\\.").replace(/,/g,"|")+")$","i"):/./},readAsDataURL:function(e,t){V.isCanvas(e)?n(e,t,"load",V.toDataURL(e)):i(e,t,"DataURL")},readAsBinaryString:function(e,t){a("BinaryString")?i(e,t,"BinaryString"):i(e,function(e){if("load"==e.type)try{e.result=V.toBinaryString(e.result)}catch(n){e.type="error",e.message=n.toString()}t(e)},"DataURL")},readAsArrayBuffer:function(e,t){i(e,t,"ArrayBuffer")},readAsText:function(e,t,n){n||(n=t,t="utf-8"),i(e,n,"Text",t)},toDataURL:function(e,t){return"string"==typeof e?e:e.toDataURL?e.toDataURL(t||"image/png"):void 0},toBinaryString:function(t){return e.atob(V.toDataURL(t).replace(E,""))},readAsImage:function(e,a,i){if(V.isFile(e))if(v){var r=v.createObjectURL(e);r===t?n(e,a,"error"):V.readAsImage(r,a,i)}else V.readAsDataURL(e,function(t){"load"==t.type?V.readAsImage(t.result,a,i):(i||"error"==t.type)&&n(e,a,t,null,{loaded:t.loaded,total:t.total})});else if(V.isCanvas(e))n(e,a,"load",e);else if(_.test(e.nodeName))if(e.complete)n(e,a,"load",e);else{var o="error abort load";J(e,o,function l(t){"load"==t.type&&v&&v.revokeObjectURL(e.src),G(e,o,l),n(e,a,t,e)})}else if(e.iframe)n(e,a,{type:"error"});else{var s=V.newImage(e.dataURL||e);V.readAsImage(s,a,i)}},checkFileObj:function(e){var t={},n=V.accept;return"object"==typeof e?t=e:t.name=(e+"").split(/\\|\//g).pop(),null==t.type&&(t.type=t.name.split(".").pop()),q(n,function(e,n){e=new RegExp(e.replace(/\s/g,"|"),"i"),(e.test(t.type)||V.ext2mime[t.type])&&(t.type=V.ext2mime[t.type]||n.split("/")[0]+"/"+t.type)}),t},getDropFiles:function(e,t){var n=[],a=c(e),i=O(a.items)&&a.items[0]&&o(a.items[0]),l=V.queue(function(){t(n)});q((i?a.items:a.files)||[],function(e){l.inc();try{i?s(e,function(e,t){e?V.log("[err] getDropFiles:",e):n.push.apply(n,t),l.next()}):r(e,function(t){t&&n.push(e),l.next()})}catch(t){l.next(),V.log("[err] getDropFiles: ",t)}}),l.check()},getFiles:function(e,t,n){var a=[];return n?(V.filterFiles(V.getFiles(e),t,n),null):(e.jquery&&(e.each(function(){a=a.concat(V.getFiles(this))}),e=a,a=[]),"string"==typeof t&&(t=V.getFilesFilter(t)),e.originalEvent?e=K(e.originalEvent):e.srcElement&&(e=K(e)),e.dataTransfer?e=e.dataTransfer:e.target&&(e=e.target),e.files?(a=e.files,R||(a[0].blob=e,a[0].iframe=!0)):!R&&u(e)?V.trim(e.value)&&(a=[V.checkFileObj(e.value)],a[0].blob=e,a[0].iframe=!0):O(e)&&(a=e),V.filter(a,function(e){return!t||t.test(e.name)}))},getTotalSize:function(e){for(var t=0,n=e&&e.length;n--;)t+=e[n].size;return t},getInfo:function(e,t){var n={},a=z.concat();V.isFile(e)?!function i(){var r=a.shift();r?r.test(e.type)?r(e,function(e,a){e?t(e):(X(n,a),i())}):i():t(!1,n)}():t("not_support_info",n)},addInfoReader:function(e,t){t.test=function(t){return e.test(t)},z.push(t)},filter:function(e,t){for(var n,a=[],i=0,r=e.length;r>i;i++)i in e&&(n=e[i],t.call(n,n,i,e)&&a.push(n));return a},filterFiles:function(e,t,n){if(e.length){var a,i=e.concat(),r=[],o=[];!function s(){i.length?(a=i.shift(),V.getInfo(a,function(e,n){(t(a,e?!1:n)?r:o).push(a),s()})):n(r,o)}()}else n([],e)},upload:function(e){e=X({jsonp:"callback",prepare:V.F,beforeupload:V.F,upload:V.F,fileupload:V.F,fileprogress:V.F,filecomplete:V.F,progress:V.F,complete:V.F,pause:V.F,imageOriginal:!0,chunkSize:V.chunkSize,chunkUploadRetry:V.chunkUploadRetry,uploadRetry:V.uploadRetry},e),e.imageAutoOrientation&&!e.imageTransform&&(e.imageTransform={rotate:"auto"});var t,n=new V.XHR(e),a=this._getFilesDataArray(e.files),i=this,r=0,o=0,s=!1;return q(a,function(e){r+=e.size}),n.files=[],q(a,function(e){n.files.push(e.file)}),n.total=r,n.loaded=0,n.filesLeft=a.length,e.beforeupload(n,e),t=function(){var u=a.shift(),c=u&&u.file,f=!1,d=l(e);if(n.filesLeft=a.length,c&&c.name===V.expando&&(c=null,V.log("[warn] FileAPI.upload() — called without files")),("abort"!=n.statusText||n.current)&&u){if(s=!1,n.currentFile=c,c&&e.prepare(c,d)===!1)return void t.call(i);d.file=c,i._getFormData(d,u,function(s){o||e.upload(n,e);var l=new V.XHR(X({},d,{upload:c?function(){e.fileupload(c,l,d)}:p,progress:c?function(t){f||(f=t.loaded===t.total,e.fileprogress({type:"progress",total:u.total=t.total,loaded:u.loaded=t.loaded},c,l,d),e.progress({type:"progress",total:r,loaded:n.loaded=o+u.size*(t.loaded/t.total)||0},c,l,d))}:p,complete:function(a){q(M,function(e){n[e]=l[e]}),c&&(u.total=u.total||u.size,u.loaded=u.total,a||(this.progress(u),f=!0,o+=u.size,n.loaded=o),e.filecomplete(a,l,c,d)),setTimeout(function(){t.call(i)},0)}}));n.abort=function(e){e||(a.length=0),this.current=e,l.abort()},l.send(s)})}else{var h=200==n.status||201==n.status||204==n.status;e.complete(h?!1:n.statusText||"error",n,e),s=!0}},setTimeout(t,0),n.append=function(e,o){e=V._getFilesDataArray([].concat(e)),q(e,function(e){r+=e.size,n.files.push(e.file),o?a.unshift(e):a.push(e)}),n.statusText="",s&&t.call(i)},n.remove=function(e){for(var t,n=a.length;n--;)a[n].file==e&&(t=a.splice(n,1),r-=t.size);return t},n},_getFilesDataArray:function(e){var t=[],n={};if(u(e)){var a=V.getFiles(e);n[e.name||"file"]=null!==e.getAttribute("multiple")?a:a[0]}else O(e)&&u(e[0])?q(e,function(e){n[e.name||"file"]=V.getFiles(e)}):n=e;return q(n,function i(e,n){O(e)?q(e,function(e){i(e,n)}):e&&(e.name||e.image)&&t.push({name:n,file:e,size:e.size,total:e.size,loaded:0})}),t.length||t.push({file:{name:V.expando}}),t},_getFormData:function(e,t,n){var a=t.file,i=t.name,r=a.name,o=a.type,s=V.support.transform&&e.imageTransform,l=new V.Form,u=V.queue(function(){n(l)}),c=s&&f(s),d=V.postNameConcat;q(e.data,function p(e,t){"object"==typeof e?q(e,function(e,n){p(e,d(t,n))}):l.append(t,e)}),function h(t){t.image?(u.inc(),t.toData(function(e,t){r=r||(new Date).getTime()+".png",h(t),u.next()})):V.Image&&s&&(/^image/.test(t.type)||U.test(t.nodeName))?(u.inc(),c&&(s=[s]),V.Image.transform(t,s,e.imageAutoOrientation,function(n,a){if(c&&!n)C||V.flashEngine||(l.multipart=!0),l.append(i,a[0],r,s[0].type||o);else{var f=0;n||q(a,function(e,t){C||V.flashEngine||(l.multipart=!0),s[t].postName||(f=1),l.append(s[t].postName||d(i,t),e,r,s[t].type||o)}),(n||e.imageOriginal)&&l.append(d(i,f?"original":null),t,r,o)}u.next()})):r!==V.expando&&l.append(i,t,r)}(a),u.check()},reset:function(e,t){var n,a;return F?(a=F(e).clone(!0).insertBefore(e).val("")[0],t||F(e).remove()):(n=e.parentNode,a=n.insertBefore(e.cloneNode(!0),e),a.value="",t||n.removeChild(e),q(k[V.uid(e)],function(t,n){q(t,function(t){G(e,n,t),W(a,n,t)})})),a},load:function(e,t){var n=V.getXHR();return n?(n.open("GET",e,!0),n.overrideMimeType&&n.overrideMimeType("text/plain; charset=x-user-defined"),W(n,"progress",function(e){e.lengthComputable&&t({type:e.type,loaded:e.loaded,total:e.total},n)}),n.onreadystatechange=function(){if(4==n.readyState)if(n.onreadystatechange=null,200==n.status){e=e.split("/");var a={name:e[e.length-1],size:n.getResponseHeader("Content-Length"),type:n.getResponseHeader("Content-Type")};a.dataURL="data:"+a.type+";base64,"+V.encode64(n.responseBody||n.responseText),t({type:"load",result:a},n)}else t({type:"error"},n)},n.send(null)):t({type:"error"}),n},encode64:function(e){var t="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",n="",a=0;for("string"!=typeof e&&(e=String(e));a<e.length;){var i,r,o=255&e.charCodeAt(a++),s=255&e.charCodeAt(a++),l=255&e.charCodeAt(a++),u=o>>2,c=(3&o)<<4|s>>4;isNaN(s)?i=r=64:(i=(15&s)<<2|l>>6,r=isNaN(l)?64:63&l),n+=t.charAt(u)+t.charAt(c)+t.charAt(i)+t.charAt(r)}return n}};V.addInfoReader(/^image/,function(e,t){if(!e.__dimensions){var n=e.__dimensions=V.defer();V.readAsImage(e,function(e){var t=e.target;n.resolve("load"==e.type?!1:"error",{width:t.width,height:t.height}),t.src=V.EMPTY_PNG,t=null})}e.__dimensions.then(t)}),V.event.dnd=function(e,t,n){var a,i;n||(n=t,t=V.F),b?(W(e,"dragenter dragleave dragover",t.ff=t.ff||function(e){for(var n=c(e).types,r=n&&n.length,o=!1;r--;)if(~n[r].indexOf("File")){e[j](),i!==e.type&&(i=e.type,"dragleave"!=i&&t.call(e[N],!0,e),o=!0);break}o&&(clearTimeout(a),a=setTimeout(function(){t.call(e[N],"dragleave"!=i,e)},50))}),W(e,"drop",n.ff=n.ff||function(e){e[j](),i=0,t.call(e[N],!1,e),V.getDropFiles(e,function(t){n.call(e[N],t,e)})})):V.log("Drag'n'Drop -- not supported")},V.event.dnd.off=function(e,t,n){G(e,"dragenter dragleave dragover",t.ff),G(e,"drop",n.ff)},F&&!F.fn.dnd&&(F.fn.dnd=function(e,t){return this.each(function(){V.event.dnd(this,e,t)})},F.fn.offdnd=function(e,t){return this.each(function(){V.event.dnd.off(this,e,t)})}),e.FileAPI=X(V,e.FileAPI),V.log("FileAPI: "+V.version),V.log("protocol: "+e.location.protocol),V.log("doctype: ["+m.name+"] "+m.publicId+" "+m.systemId),q(h.getElementsByTagName("meta"),function(e){/x-ua-compatible/i.test(e.getAttribute("http-equiv"))&&V.log("meta.http-equiv: "+e.getAttribute("content"))}),V.flashUrl||(V.flashUrl=V.staticPath+"FileAPI.flash.swf"),V.flashImageUrl||(V.flashImageUrl=V.staticPath+"FileAPI.flash.image.swf"),V.flashWebcamUrl||(V.flashWebcamUrl=V.staticPath+"FileAPI.flash.camera.swf")}(window,void 0),function(e,t,n){"use strict";function a(t){if(t instanceof a){var n=new a(t.file);return e.extend(n.matrix,t.matrix),n}return this instanceof a?(this.file=t,this.size=t.size||100,void(this.matrix={sx:0,sy:0,sw:0,sh:0,dx:0,dy:0,dw:0,dh:0,resize:0,deg:0,quality:1,filter:0})):new a(t)}var i=Math.min,r=Math.round,o=function(){return t.createElement("canvas")},s=!1,l={8:270,3:180,6:90,7:270,4:180,5:90};try{s=o().toDataURL("image/png").indexOf("data:image/png")>-1}catch(u){}a.prototype={image:!0,constructor:a,set:function(t){return e.extend(this.matrix,t),this},crop:function(e,t,a,i){return a===n&&(a=e,i=t,e=t=0),this.set({sx:e,sy:t,sw:a,sh:i||a})},resize:function(e,t,n){return/min|max|height|width/.test(t)&&(n=t,t=e),this.set({dw:e,dh:t||e,resize:n})},preview:function(e,t){return this.resize(e,t||e,"preview")},rotate:function(e){return this.set({deg:e})},filter:function(e){return this.set({filter:e})},overlay:function(e){return this.set({overlay:e})},clone:function(){return new a(this)},_load:function(t,n){var a=this;/img|video/i.test(t.nodeName)?n.call(a,null,t):e.readAsImage(t,function(e){n.call(a,"load"!=e.type,e.result)})},_apply:function(t,n){var r,s=o(),l=this.getMatrix(t),u=s.getContext("2d"),c=t.videoWidth||t.width,f=t.videoHeight||t.height,d=l.deg,p=l.dw,h=l.dh,m=c,g=f,v=l.filter,y=t,w=l.overlay,b=e.queue(function(){t.src=e.EMPTY_PNG,n(!1,s)}),x=e.renderImageToCanvas;for(d-=360*Math.floor(d/360),t._type=this.file.type;l.multipass&&i(m/p,g/h)>2;)m=m/2+.5|0,g=g/2+.5|0,r=o(),r.width=m,r.height=g,y!==t?(x(r,y,0,0,y.width,y.height,0,0,m,g),y=r):(y=r,x(y,t,l.sx,l.sy,l.sw,l.sh,0,0,m,g),l.sx=l.sy=l.sw=l.sh=0);s.width=d%180?h:p,s.height=d%180?p:h,s.type=l.type,s.quality=l.quality,u.rotate(d*Math.PI/180),x(u.canvas,y,l.sx,l.sy,l.sw||y.width,l.sh||y.height,180==d||270==d?-p:0,90==d||180==d?-h:0,p,h),p=s.width,h=s.height,w&&e.each([].concat(w),function(t){b.inc();var n=new window.Image,a=function(){var i=0|t.x,r=0|t.y,o=t.w||n.width,s=t.h||n.height,l=t.rel;i=1==l||4==l||7==l?(p-o+i)/2:2==l||5==l||8==l?p-(o+i):i,r=3==l||4==l||5==l?(h-s+r)/2:l>=6?h-(s+r):r,e.event.off(n,"error load abort",a);try{u.globalAlpha=t.opacity||1,u.drawImage(n,i,r,o,s)}catch(c){}b.next()};e.event.on(n,"error load abort",a),n.src=t.src,n.complete&&a()}),v&&(b.inc(),a.applyFilter(s,v,b.next)),b.check()},getMatrix:function(t){var n=e.extend({},this.matrix),a=n.sw=n.sw||t.videoWidth||t.naturalWidth||t.width,o=n.sh=n.sh||t.videoHeight||t.naturalHeight||t.height,s=n.dw=n.dw||a,l=n.dh=n.dh||o,u=a/o,c=s/l,f=n.resize;if("preview"==f){if(s!=a||l!=o){var d,p;c>=u?(d=a,p=d/c):(p=o,d=p*c),(d!=a||p!=o)&&(n.sx=~~((a-d)/2),n.sy=~~((o-p)/2),a=d,o=p)}}else"height"==f?s=l*u:"width"==f?l=s/u:f&&(a>s||o>l?"min"==f?(s=r(c>u?i(a,s):l*u),l=r(c>u?s/u:i(o,l))):(s=r(u>=c?i(a,s):l*u),l=r(u>=c?s/u:i(o,l))):(s=a,l=o));return n.sw=a,n.sh=o,n.dw=s,n.dh=l,n.multipass=e.multiPassResize,n},_trans:function(t){this._load(this.file,function(n,a){if(n)t(n);else try{this._apply(a,t)}catch(n){e.log("[err] FileAPI.Image.fn._apply:",n),t(n)}})},get:function(t){if(e.support.transform){var n=this,a=n.matrix;"auto"==a.deg?e.getInfo(n.file,function(e,i){a.deg=l[i&&i.exif&&i.exif.Orientation]||0,n._trans(t)}):n._trans(t)}else t("not_support_transform");return this},toData:function(e){return this.get(e)}},a.exifOrientation=l,a.transform=function(t,i,r,o){function s(s,l){var u={},c=e.queue(function(e){o(e,u)});s?c.fail():e.each(i,function(e,i){if(!c.isFail()){var o=new a(l.nodeType?l:t),s="function"==typeof e;if(s?e(l,o):e.width?o[e.preview?"preview":"resize"](e.width,e.height,e.strategy):e.maxWidth&&(l.width>e.maxWidth||l.height>e.maxHeight)&&o.resize(e.maxWidth,e.maxHeight,"max"),e.crop){var f=e.crop;o.crop(0|f.x,0|f.y,f.w||f.width,f.h||f.height)}e.rotate===n&&r&&(e.rotate="auto"),o.set({type:o.matrix.type||e.type||t.type||"image/png"}),s||o.set({deg:e.rotate,overlay:e.overlay,filter:e.filter,quality:e.quality||1}),c.inc(),o.toData(function(e,t){e?c.fail():(u[i]=t,c.next())})}})}t.width?s(!1,t):e.getInfo(t,s)},e.each(["TOP","CENTER","BOTTOM"],function(t,n){e.each(["LEFT","CENTER","RIGHT"],function(e,i){a[t+"_"+e]=3*n+i,a[e+"_"+t]=3*n+i})}),a.toCanvas=function(e){var n=t.createElement("canvas");return n.width=e.videoWidth||e.width,n.height=e.videoHeight||e.height,n.getContext("2d").drawImage(e,0,0),n},a.fromDataURL=function(t,n,a){var i=e.newImage(t);e.extend(i,n),a(i)},a.applyFilter=function(t,n,i){"function"==typeof n?n(t,i):window.Caman&&window.Caman("IMG"==t.tagName?a.toCanvas(t):t,function(){"string"==typeof n?this[n]():e.each(n,function(e,t){this[t](e)},this),this.render(i)})},e.renderImageToCanvas=function(t,n,a,i,r,o,s,l,u,c){try{return t.getContext("2d").drawImage(n,a,i,r,o,s,l,u,c)}catch(f){throw e.log("renderImageToCanvas failed"),f}},e.support.canvas=e.support.transform=s,e.Image=a}(FileAPI,document),function(e){"use strict";e(FileAPI)}(function(e){"use strict";if(window.navigator&&window.navigator.platform&&/iP(hone|od|ad)/.test(window.navigator.platform)){var t=e.renderImageToCanvas;e.detectSubsampling=function(e){var t,n;return e.width*e.height>1048576?(t=document.createElement("canvas"),t.width=t.height=1,n=t.getContext("2d"),n.drawImage(e,-e.width+1,0),0===n.getImageData(0,0,1,1).data[3]):!1},e.detectVerticalSquash=function(e,t){var n,a,i,r,o,s=e.naturalHeight||e.height,l=document.createElement("canvas"),u=l.getContext("2d");for(t&&(s/=2),l.width=1,l.height=s,u.drawImage(e,0,0),n=u.getImageData(0,0,1,s).data,a=0,i=s,r=s;r>a;)o=n[4*(r-1)+3],0===o?i=r:a=r,r=i+a>>1;return r/s||1},e.renderImageToCanvas=function(n,a,i,r,o,s,l,u,c,f){if("image/jpeg"===a._type){var d,p,h,m,g=n.getContext("2d"),v=document.createElement("canvas"),y=1024,w=v.getContext("2d");if(v.width=y,v.height=y,g.save(),d=e.detectSubsampling(a),d&&(i/=2,r/=2,o/=2,s/=2),p=e.detectVerticalSquash(a,d),d||1!==p){for(r*=p,c=Math.ceil(y*c/o),f=Math.ceil(y*f/s/p),u=0,m=0;s>m;){for(l=0,h=0;o>h;)w.clearRect(0,0,y,y),w.drawImage(a,i,r,o,s,-h,-m,o,s),g.drawImage(v,0,0,y,y,l,u,c,f),h+=y,l+=c;m+=y,u+=f}return g.restore(),n}}return t(n,a,i,r,o,s,l,u,c,f)}}}),function(e,t){"use strict";function n(t,n,a){var i=t.blob,r=t.file;if(r){if(!i.toDataURL)return void e.readAsBinaryString(i,function(e){"load"==e.type&&n(t,e.result)});var o={"image/jpeg":".jpe?g","image/png":".png"},s=o[t.type]?t.type:"image/png",l=o[s]||".png",u=i.quality||1;r.match(new RegExp(l+"$","i"))||(r+=l.replace("?","")),t.file=r,t.type=s,!a&&i.toBlob?i.toBlob(function(e){n(t,e)},s,u):n(t,e.toBinaryString(i.toDataURL(s,u)))}else n(t,i)}var a=t.document,i=t.FormData,r=function(){this.items=[]},o=t.encodeURIComponent;r.prototype={append:function(e,t,n,a){this.items.push({name:e,blob:t&&t.blob||(void 0==t?"":t),file:t&&(n||t.name),type:t&&(a||t.type)})},each:function(e){for(var t=0,n=this.items.length;n>t;t++)e.call(this,this.items[t])},toData:function(t,n){n._chunked=e.support.chunked&&n.chunkSize>0&&1==e.filter(this.items,function(e){return e.file}).length,e.support.html5?e.formData&&!this.multipart&&i?n._chunked?(e.log("FileAPI.Form.toPlainData"),this.toPlainData(t)):(e.log("FileAPI.Form.toFormData"),this.toFormData(t)):(e.log("FileAPI.Form.toMultipartData"),this.toMultipartData(t)):(e.log("FileAPI.Form.toHtmlData"),this.toHtmlData(t))},_to:function(t,n,a,i){var r=e.queue(function(){n(t)});this.each(function(e){a(e,t,r,i)}),r.check()},toHtmlData:function(t){this._to(a.createDocumentFragment(),t,function(t,n){var i,r=t.blob;t.file?(e.reset(r,!0),r.name=t.name,r.disabled=!1,n.appendChild(r)):(i=a.createElement("input"),i.name=t.name,i.type="hidden",i.value=r,n.appendChild(i))})},toPlainData:function(e){this._to({},e,function(e,t,a){e.file&&(t.type=e.file),e.blob.toBlob?(a.inc(),n(e,function(e,n){t.name=e.name,t.file=n,t.size=n.length,t.type=e.type,a.next()})):e.file?(t.name=e.blob.name,t.file=e.blob,t.size=e.blob.size,t.type=e.type):(t.params||(t.params=[]),t.params.push(o(e.name)+"="+o(e.blob))),t.start=-1,t.end=t.file&&t.file.FileAPIReadPosition||-1,t.retry=0})},toFormData:function(e){this._to(new i,e,function(e,t,a){e.blob&&e.blob.toBlob?(a.inc(),n(e,function(e,n){t.append(e.name,n,e.file),a.next()})):e.file?t.append(e.name,e.blob,e.file):t.append(e.name,e.blob),e.file&&t.append("_"+e.name,e.file)})},toMultipartData:function(t){this._to([],t,function(e,t,a,i){a.inc(),n(e,function(e,n){t.push("--_"+i+('\r\nContent-Disposition: form-data; name="'+e.name+'"'+(e.file?'; filename="'+o(e.file)+'"':"")+(e.file?"\r\nContent-Type: "+(e.type||"application/octet-stream"):"")+"\r\n\r\n"+(e.file?n:o(n))+"\r\n")),a.next()},!0)},e.expando)}},e.Form=r}(FileAPI,window),function(e,t){"use strict";var n=function(){},a=e.document,i=function(e){this.uid=t.uid(),this.xhr={abort:n,getResponseHeader:n,getAllResponseHeaders:n},this.options=e},r={"":1,XML:1,Text:1,Body:1};i.prototype={status:0,statusText:"",constructor:i,getResponseHeader:function(e){return this.xhr.getResponseHeader(e)},getAllResponseHeaders:function(){return this.xhr.getAllResponseHeaders()||{}},end:function(a,i){var r=this,o=r.options;r.end=r.abort=n,r.status=a,i&&(r.statusText=i),t.log("xhr.end:",a,i),o.complete(200==a||201==a?!1:r.statusText||"unknown",r),r.xhr&&r.xhr.node&&setTimeout(function(){var t=r.xhr.node;try{t.parentNode.removeChild(t)}catch(n){}try{delete e[r.uid]}catch(n){}e[r.uid]=r.xhr.node=null},9)},abort:function(){this.end(0,"abort"),this.xhr&&(this.xhr.aborted=!0,this.xhr.abort())},send:function(e){var t=this,n=this.options;e.toData(function(e){n.upload(n,t),t._send.call(t,n,e)},n)},_send:function(n,i){var o,s=this,l=s.uid,u=s.uid+"Load",c=n.url;if(t.log("XHR._send:",i),n.cache||(c+=(~c.indexOf("?")?"&":"?")+t.uid()),i.nodeName){var f=n.jsonp;c=c.replace(/([a-z]+)=(\?)/i,"$1="+l),n.upload(n,s);var d=function(e){if(~c.indexOf(e.origin))try{var n=t.parseJSON(e.data);n.id==l&&p(n.status,n.statusText,n.response)}catch(a){p(0,a.message)}},p=e[l]=function(n,a,i){s.readyState=4,s.responseText=i,s.end(n,a),t.event.off(e,"message",d),e[l]=o=m=e[u]=null};s.xhr.abort=function(){try{m.stop?m.stop():m.contentWindow.stop?m.contentWindow.stop():m.contentWindow.document.execCommand("Stop")}catch(e){}p(0,"abort")},t.event.on(e,"message",d),e[u]=function(){try{var e=m.contentWindow,n=e.document,a=e.result||t.parseJSON(n.body.innerHTML);p(a.status,a.statusText,a.response)}catch(i){t.log("[transport.onload]",i)}},o=a.createElement("div"),o.innerHTML='<form target="'+l+'" action="'+c+'" method="POST" enctype="multipart/form-data" style="position: absolute; top: -1000px; overflow: hidden; width: 1px; height: 1px;"><iframe name="'+l+'" src="javascript:false;" onload="'+u+'()"></iframe>'+(f&&n.url.indexOf("=?")<0?'<input value="'+l+'" name="'+f+'" type="hidden"/>':"")+"</form>";var h=o.getElementsByTagName("form")[0],m=o.getElementsByTagName("iframe")[0];h.appendChild(i),t.log(h.parentNode.innerHTML),a.body.appendChild(o),s.xhr.node=o,s.readyState=2,h.submit(),h=null}else{if(c=c.replace(/([a-z]+)=(\?)&?/i,""),this.xhr&&this.xhr.aborted)return void t.log("Error: already aborted");if(o=s.xhr=t.getXHR(),i.params&&(c+=(c.indexOf("?")<0?"?":"&")+i.params.join("&")),o.open("POST",c,!0),t.withCredentials&&(o.withCredentials="true"),n.headers&&n.headers["X-Requested-With"]||o.setRequestHeader("X-Requested-With","XMLHttpRequest"),t.each(n.headers,function(e,t){o.setRequestHeader(t,e)}),n._chunked){o.upload&&o.upload.addEventListener("progress",t.throttle(function(e){i.retry||n.progress({type:e.type,total:i.size,loaded:i.start+e.loaded,totalSize:i.size},s,n)},100),!1),o.onreadystatechange=function(){var e=parseInt(o.getResponseHeader("X-Last-Known-Byte"),10);if(s.status=o.status,s.statusText=o.statusText,s.readyState=o.readyState,4==o.readyState){for(var a in r)s["response"+a]=o["response"+a];if(o.onreadystatechange=null,!o.status||o.status-201>0)if(t.log("Error: "+o.status),(!o.status&&!o.aborted||500==o.status||416==o.status)&&++i.retry<=n.chunkUploadRetry){var l=o.status?0:t.chunkNetworkDownRetryTimeout;n.pause(i.file,n),t.log("X-Last-Known-Byte: "+e),e?i.end=e:(i.end=i.start-1,416==o.status&&(i.end=i.end-n.chunkSize)),setTimeout(function(){s._send(n,i)},l)}else s.end(o.status);else i.retry=0,i.end==i.size-1?s.end(o.status):(t.log("X-Last-Known-Byte: "+e),e&&(i.end=e),i.file.FileAPIReadPosition=i.end,setTimeout(function(){s._send(n,i)},0));o=null}},i.start=i.end+1,i.end=Math.max(Math.min(i.start+n.chunkSize,i.size)-1,i.start);var g=i.file,v=(g.slice||g.mozSlice||g.webkitSlice).call(g,i.start,i.end+1);i.size&&!v.size?setTimeout(function(){s.end(-1)}):(o.setRequestHeader("Content-Range","bytes "+i.start+"-"+i.end+"/"+i.size),o.setRequestHeader("Content-Disposition","attachment; filename="+encodeURIComponent(i.name)),o.setRequestHeader("Content-Type",i.type||"application/octet-stream"),o.send(v)),g=v=null}else if(o.upload&&o.upload.addEventListener("progress",t.throttle(function(e){n.progress(e,s,n)},100),!1),o.onreadystatechange=function(){if(s.status=o.status,s.statusText=o.statusText,s.readyState=o.readyState,4==o.readyState){for(var e in r)s["response"+e]=o["response"+e];if(o.onreadystatechange=null,!o.status||o.status>201)if(t.log("Error: "+o.status),(!o.status&&!o.aborted||500==o.status)&&(n.retry||0)<n.uploadRetry){n.retry=(n.retry||0)+1;var a=t.networkDownRetryTimeout;n.pause(n.file,n),setTimeout(function(){s._send(n,i)},a)}else s.end(o.status);else s.end(o.status);o=null}},t.isArray(i)){o.setRequestHeader("Content-Type","multipart/form-data; boundary=_"+t.expando);var y=i.join("")+"--_"+t.expando+"--";if(o.sendAsBinary)o.sendAsBinary(y);else{var w=Array.prototype.map.call(y,function(e){return 255&e.charCodeAt(0)});o.send(new Uint8Array(w).buffer)}}else o.send(i)}}},t.XHR=i}(window,FileAPI),function(e,t){"use strict";function n(e){return e>=0?e+"px":e}function a(e){var t,n=r.createElement("canvas"),a=!1;try{t=n.getContext("2d"),t.drawImage(e,0,0,1,1),a=255!=t.getImageData(0,0,1,1).data[4]}catch(i){}return a}var i=e.URL||e.webkitURL,r=e.document,o=e.navigator,s=o.getUserMedia||o.webkitGetUserMedia||o.mozGetUserMedia||o.msGetUserMedia,l=!!s;t.support.media=l;var u=function(e){this.video=e};u.prototype={isActive:function(){return!!this._active},start:function(e){var t,n,r=this,l=r.video,u=function(a){r._active=!a,clearTimeout(n),clearTimeout(t),e&&e(a,r)};s.call(o,{video:!0},function(e){r.stream=e,l.src=i.createObjectURL(e),t=setInterval(function(){a(l)&&u(null)},1e3),n=setTimeout(function(){u("timeout")},5e3),l.play()},u)},stop:function(){try{this._active=!1,this.video.pause(),this.stream.stop()}catch(e){}},shot:function(){return new c(this.video)}},u.get=function(e){return new u(e.firstChild)},u.publish=function(a,i,o){"function"==typeof i&&(o=i,i={}),i=t.extend({},{width:"100%",height:"100%",start:!0},i),a.jquery&&(a=a[0]);var s=function(e){if(e)o(e);else{var t=u.get(a);i.start?t.start(o):o(null,t)}};if(a.style.width=n(i.width),a.style.height=n(i.height),t.html5&&l){var c=r.createElement("video");c.style.width=n(i.width),c.style.height=n(i.height),e.jQuery?jQuery(a).empty():a.innerHTML="",a.appendChild(c),s()}else u.fallback(a,i,s)},u.fallback=function(e,t,n){n("not_support_camera")};var c=function(e){var n=e.nodeName?t.Image.toCanvas(e):e,a=t.Image(n);return a.type="image/png",a.width=n.width,a.height=n.height,a.size=n.width*n.height*4,a};u.Shot=c,t.Camera=u}(window,FileAPI),function(e,t,n){"use strict";var a=n.each,i=[];n.support.flash&&n.media&&!n.support.media&&!function(){function e(e){var t=e.wid=n.uid();return n.Flash._fn[t]=e,"FileAPI.Flash._fn."+t}function t(e){try{n.Flash._fn[e.wid]=null,delete n.Flash._fn[e.wid]
}catch(t){}}var r=n.Flash;n.extend(n.Flash,{patchCamera:function(){n.Camera.fallback=function(a,i,o){var s=n.uid();n.log("FlashAPI.Camera.publish: "+s),r.publish(a,s,n.extend(i,{camera:!0,onEvent:e(function l(e){"camera"===e.type&&(t(l),e.error?(n.log("FlashAPI.Camera.publish.error: "+e.error),o(e.error)):(n.log("FlashAPI.Camera.publish.success: "+s),o(null)))})}))},a(i,function(e){n.Camera.fallback.apply(n.Camera,e)}),i=[],n.extend(n.Camera.prototype,{_id:function(){return this.video.id},start:function(a){var i=this;r.cmd(this._id(),"camera.on",{callback:e(function o(e){t(o),e.error?(n.log("FlashAPI.camera.on.error: "+e.error),a(e.error,i)):(n.log("FlashAPI.camera.on.success: "+i._id()),i._active=!0,a(null,i))})})},stop:function(){this._active=!1,r.cmd(this._id(),"camera.off")},shot:function(){n.log("FlashAPI.Camera.shot:",this._id());var e=n.Flash.cmd(this._id(),"shot",{});return e.type="image/png",e.flashId=this._id(),e.isShot=!0,new n.Camera.Shot(e)}})}}),n.Camera.fallback=function(){i.push(arguments)}}()}(window,window.jQuery,FileAPI),"function"==typeof define&&define.amd&&define("FileAPI",[],function(){return FileAPI});