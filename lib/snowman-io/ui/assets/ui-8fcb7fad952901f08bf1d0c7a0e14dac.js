define("ui/adapters/application",["ember-data","ui/config/environment","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=a.RESTAdapter.extend({host:n.baseHost,namespace:"api"})}),define("ui/app",["ember","ember/resolver","ember/load-initializers","ui/config/environment","exports"],function(e,t,s,a,n){"use strict";var r=e["default"],i=t["default"],o=s["default"],l=a["default"];r.MODEL_FACTORY_INJECTIONS=!0;var u=r.Application.extend({modulePrefix:l.modulePrefix,podModulePrefix:l.podModulePrefix,Resolver:i});o(u,l.modulePrefix),n["default"]=u}),define("ui/controllers/apps/edit",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.ObjectController.extend({actions:{save:function(){var e=this,t=this.model;t.save().then(function(){e.transitionToRoute("dashboard")})}}})}),define("ui/controllers/apps/new",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.ObjectController.extend({actions:{save:function(){var e=this,t=this.model;t.save().then(function(){e.transitionToRoute("apps/show",t.id)})}}})}),define("ui/controllers/apps/show",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.ObjectController.extend({hasRequests:function(){return this.get("app.requests.today")&&this.get("app.requests.yesterday")}.property()})}),define("ui/controllers/dashboard",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.ObjectController.extend({actions:{destroy:function(e){confirm("Are you sure?")&&(e.deleteRecord(),e.save())}}})}),define("ui/controllers/login",["ember","simple-auth/mixins/login-controller-mixin","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=a.Controller.extend(n,{authenticator:"simple-auth-authenticator:devise",actions:{authenticate:function(){var e=this;this._super().then(null,function(t){e.set("errorMessage",t.message)})}}})}),define("ui/controllers/unpacking",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.ObjectController.extend({actions:{setup:function(){var e=this,t=this.get("model");t.save().then(function(){var s={identification:t.get("email"),password:t.get("password")};e.get("session").authenticate("simple-auth-authenticator:devise",s).then(function(){e.transitionToRoute("dashboard")})})}}})}),define("ui/initializers/ember-moment",["ember-moment/helpers/moment","ember-moment/helpers/ago","ember-moment/helpers/duration","ember","exports"],function(e,t,s,a,n){"use strict";var r=e["default"],i=t["default"],o=s["default"],l=a["default"],u=function(){var e;e=l.HTMLBars?function(e,t){l.HTMLBars._registerHelper(e,l.HTMLBars.makeBoundHelper(t))}:l.Handlebars.helper,e("moment",r),e("ago",i),e("duration",o)};n.initialize=u,n["default"]={name:"ember-moment",initialize:u}}),define("ui/initializers/export-application-global",["ember","ui/config/environment","exports"],function(e,t,s){"use strict";function a(e,t){var s=n.String.classify(r.modulePrefix);r.exportApplicationGlobal&&!window[s]&&(window[s]=t)}var n=e["default"],r=t["default"];s.initialize=a,s["default"]={name:"export-application-global",initialize:a}}),define("ui/initializers/simple-auth-devise",["simple-auth-devise/configuration","simple-auth-devise/authenticators/devise","simple-auth-devise/authorizers/devise","ui/config/environment","exports"],function(e,t,s,a,n){"use strict";var r=e["default"],i=t["default"],o=s["default"],l=a["default"];n["default"]={name:"simple-auth-devise",before:"simple-auth",initialize:function(e){r.load(e,l["simple-auth-devise"]||{}),e.register("simple-auth-authorizer:devise",o),e.register("simple-auth-authenticator:devise",i)}}}),define("ui/initializers/simple-auth",["simple-auth/configuration","simple-auth/setup","ui/config/environment","exports"],function(e,t,s,a){"use strict";var n=e["default"],r=t["default"],i=s["default"];a["default"]={name:"simple-auth",initialize:function(e,t){n.load(e,i["simple-auth"]||{}),r(e,t)}}}),define("ui/mixins/live-pooling",["ember","ui/utils/pollster","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=a.Mixin.create({actions:{didTransition:function(){this.set("pollster",n.create({onPoll:this.onPoll})),this.get("pollster").start(this)},willTransition:function(){this.get("pollster").stop(),this.set("pollster",null)}}})}),define("ui/utils/pollster",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Object.extend({interval:function(){return 3e3}.property(),schedule:function(e,t){return s.run.later(this,function(){t.apply(e),this.set("timer",this.schedule(e,t))},this.get("interval"))},stop:function(){s.run.cancel(this.get("timer"))},start:function(e){this.set("timer",this.schedule(e,this.get("onPoll")))},onPoll:function(){throw"implement this"}})}),define("ui/models/app",["ember","ember-data","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=n.Model.extend({name:n.attr("string"),token:n.attr("string"),requestsJSON:n.attr("string"),isNameEmpty:a.computed.empty("name"),requests:function(){return JSON.parse(this.get("requestsJSON"))}.property("requestsJSON")})}),define("ui/models/user",["ember-data","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Model.extend({email:s.attr("string"),password:s.attr("string")})}),define("ui/router",["ember","ui/config/environment","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"],r=a.Router.extend({location:n.locationType});r.map(function(){this.route("unpacking"),this.route("login"),this.route("dashboard",{path:"/"}),this.route("settings"),this.route("apps/new",{path:"/apps/new"}),this.route("apps/show",{path:"/apps/:id"}),this.route("apps/edit",{path:"/apps/:id/edit"}),this.route("signup")}),s["default"]=r}),define("ui/routes/application",["simple-auth/mixins/application-route-mixin","ember","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=n.Route.extend(a)}),define("ui/routes/apps/edit",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Route.extend({model:function(e){return this.store.find("app",e.id)},deactivate:function(){this.controller.get("model.isDirty")&&this.controller.get("model").rollback()}})}),define("ui/routes/apps/new",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Route.extend({model:function(){return this.store.createRecord("app")},deactivate:function(){this.controller.get("model.isNew")&&this.controller.get("model").rollback()}})}),define("ui/routes/apps/show",["ember","ui/mixins/live-pooling","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=a.Route.extend(n,{model:function(e){return a.RSVP.hash({app:this.store.fetch("app",e.id),info:a.$.get(this._infoUrl())})},onPoll:function(){this.refresh()},_infoUrl:function(){var e=this.container.lookup("adapter:application");return e.buildURL("")+"/info"}})}),define("ui/routes/dashboard",["ember","ui/mixins/live-pooling","simple-auth/mixins/authenticated-route-mixin","exports"],function(e,t,s,a){"use strict";var n=e["default"],r=t["default"],i=s["default"];a["default"]=n.Route.extend(r,i,{model:function(){return n.RSVP.hash({apps:this.store.find("app")})},onPoll:function(){this.refresh()}})}),define("ui/routes/login",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Route.extend({setupController:function(e){e.set("errorMessage",null)}})}),define("ui/routes/settings",["ember","simple-auth/mixins/authenticated-route-mixin","exports"],function(e,t,s){"use strict";var a=e["default"],n=t["default"];s["default"]=a.Route.extend(n,{model:function(){return a.$.get(this._infoUrl())},_infoUrl:function(){var e=this.container.lookup("adapter:application");return e.buildURL("")+"/info"}})}),define("ui/routes/unpacking",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Route.extend({model:function(){return this.store.createRecord("user")},deactivate:function(){this.controller.get("model.isNew")&&this.controller.get("model").rollback()}})}),define("ui/templates/application",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){var s,n,r,i="";return t.buffer.push('\n  <nav class="navbar navbar-inverse">\n    <div class="container-fluid">\n      <div class="navbar-header">\n        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">\n          <span class="sr-only">Toggle navigation</span>\n          <span class="icon-bar"></span>\n          <span class="icon-bar"></span>\n          <span class="icon-bar"></span>\n        </button>\n        <span class="navbar-brand">SnowmanIO</a>\n      </div>\n\n      <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">\n        <ul class="nav navbar-nav">\n          '),n=a["link-to"]||e&&e["link-to"],r={hash:{tagName:"li",href:!1},hashTypes:{tagName:"STRING",href:"BOOLEAN"},hashContexts:{tagName:e,href:e},inverse:c.noop,fn:c.program(2,o,t),contexts:[e],types:["STRING"],data:t},s=n?n.call(e,"dashboard",r):d.call(e,"link-to","dashboard",r),(s||0===s)&&t.buffer.push(s),t.buffer.push("\n\n          "),n=a["link-to"]||e&&e["link-to"],r={hash:{tagName:"li",href:!1},hashTypes:{tagName:"STRING",href:"BOOLEAN"},hashContexts:{tagName:e,href:e},inverse:c.noop,fn:c.program(5,u,t),contexts:[e],types:["STRING"],data:t},s=n?n.call(e,"settings",r):d.call(e,"link-to","settings",r),(s||0===s)&&t.buffer.push(s),t.buffer.push('\n        </ul>\n        <ul class="nav navbar-nav navbar-right">\n          <li>\n            <a href="#" '),t.buffer.push(b(a.action.call(e,"invalidateSession",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["STRING"],data:t}))),t.buffer.push(">Logout</a>\n          </li>\n        </ul>\n      </div>\n    </div>\n  </nav>\n"),i}function o(e,t){var s,n,r,i="";return t.buffer.push("\n            "),n=a["link-to"]||e&&e["link-to"],r={hash:{},hashTypes:{},hashContexts:{},inverse:c.noop,fn:c.program(3,l,t),contexts:[e],types:["STRING"],data:t},s=n?n.call(e,"dashboard",r):d.call(e,"link-to","dashboard",r),(s||0===s)&&t.buffer.push(s),t.buffer.push("\n          "),i}function l(e,t){t.buffer.push("Dashboard")}function u(e,t){var s,n,r,i="";return t.buffer.push("\n            "),n=a["link-to"]||e&&e["link-to"],r={hash:{},hashTypes:{},hashContexts:{},inverse:c.noop,fn:c.program(6,p,t),contexts:[e],types:["STRING"],data:t},s=n?n.call(e,"settings",r):d.call(e,"link-to","settings",r),(s||0===s)&&t.buffer.push(s),t.buffer.push("\n          "),i}function p(e,t){t.buffer.push("Settings")}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var h,f="",c=this,d=a.helperMissing,b=this.escapeExpression;return h=a["if"].call(t,"session.isAuthenticated",{hash:{},hashTypes:{},hashContexts:{},inverse:c.noop,fn:c.program(1,i,r),contexts:[t],types:["ID"],data:r}),(h||0===h)&&r.buffer.push(h),r.buffer.push("\n\n<div "),r.buffer.push(b(a["bind-attr"].call(t,{hash:{"class":":container-main isAuthenticated:container-fluid:container"},hashTypes:{"class":"STRING"},hashContexts:{"class":t},contexts:[],types:[],data:r}))),r.buffer.push(">\n  "),h=a._triageMustache.call(t,"outlet",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(h||0===h)&&r.buffer.push(h),r.buffer.push("\n</div>\n"),f})}),define("ui/templates/apps/_form",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){t.buffer.push("\n          Register\n        ")}function o(e,t){t.buffer.push("\n          Update\n        ")}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var l,u,p,h="",f=a.helperMissing,c=this.escapeExpression,d=this;return r.buffer.push('<form class="form-horizontal">\n  <div class="form-group">\n    <label for="inputName" class="col-sm-2 control-label">Name</label>\n    <div class="col-sm-8">\n      '),r.buffer.push(c((u=a.input||t&&t.input,p={hash:{"class":"form-control",id:"inputName",value:"name",placeholder:"Application Name"},hashTypes:{"class":"STRING",id:"STRING",value:"ID",placeholder:"STRING"},hashContexts:{"class":t,id:t,value:t,placeholder:t},contexts:[],types:[],data:r},u?u.call(t,p):f.call(t,"input",p)))),r.buffer.push('\n    </div>\n  </div>\n  <div class="form-group">\n    <div class="col-sm-offset-2 col-sm-8">\n      <button type="submit" class="btn btn-primary" '),r.buffer.push(c(a["bind-attr"].call(t,{hash:{disabled:"isNameEmpty"},hashTypes:{disabled:"ID"},hashContexts:{disabled:t},contexts:[],types:[],data:r}))),r.buffer.push(" "),r.buffer.push(c(a.action.call(t,"save",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["STRING"],data:r}))),r.buffer.push(">\n        "),l=a["if"].call(t,"model.isNew",{hash:{},hashTypes:{},hashContexts:{},inverse:d.program(3,o,r),fn:d.program(1,i,r),contexts:[t],types:["ID"],data:r}),(l||0===l)&&r.buffer.push(l),r.buffer.push("\n      </button>\n    </div>\n  </div>\n</form>\n"),h})}),define("ui/templates/apps/_info",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){var s;s=a._triageMustache.call(e,"app.requests.today.count",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),t.buffer.push(s||0===s?s:"")}function o(e,t){t.buffer.push("-")}function l(e,t){var s;s=a._triageMustache.call(e,"app.requests.yesterday.count",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),t.buffer.push(s||0===s?s:"")}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var u,p="",h=this;return r.buffer.push('<div class="row-fluid app-slot">\n  <table class="table table-striped" style="width:30%">\n    <tr>\n      <th colspan="2">Requests</th>\n    </tr>\n    <tr>\n      <td>\n        <b>Today</b><br>\n        '),u=a["if"].call(t,"app.requests.today",{hash:{},hashTypes:{},hashContexts:{},inverse:h.program(3,o,r),fn:h.program(1,i,r),contexts:[t],types:["ID"],data:r}),(u||0===u)&&r.buffer.push(u),r.buffer.push("\n      </td>\n      <td>\n        <b>Yesterday</b><br>\n        "),u=a["if"].call(t,"app.requests.yesterday",{hash:{},hashTypes:{},hashContexts:{},inverse:h.program(3,o,r),fn:h.program(5,l,r),contexts:[t],types:["ID"],data:r}),(u||0===u)&&r.buffer.push(u),r.buffer.push("\n      </td>\n    </tr>\n  </table>\n</div>\n"),p})}),define("ui/templates/apps/_install",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var i,o="";return r.buffer.push("<h4>1. Add snowagent to application Gemfile</h4>\n<code>\ngem 'snowagent'\n</code>\n\n<h4>2. Configure application</h4>\n<b>Heroku:</b>\n<pre>\nheroku config:set \\\n  SNOWMANIO_SERVER="),i=a._triageMustache.call(t,"info.base_url",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push(" \\\n  SNOWMANIO_SECRET_TOKEN="),i=a._triageMustache.call(t,"app.token",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push("\n</pre>\n\n<b>Standalone:</b>\n<pre>\nTODO: add description\n</pre>\n\n<h2>Send Test Request</h2>\n<pre>\ncurl "),i=a._triageMustache.call(t,"info.base_url",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push('/agent/metrics -d \'{"token":"'),i=a._triageMustache.call(t,"app.token",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push('","metrics":[{"name":"request","value":0.15,"kind":"request"}]}\'\n</pre>\n'),o})}),define("ui/templates/apps/edit",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var i,o,l="",u=a.helperMissing,p=this.escapeExpression;return r.buffer.push('<div class="page-header">\n  <h1>Edit Application</h1>\n</div>\n\n'),r.buffer.push(p((i=a.partial||t&&t.partial,o={hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["STRING"],data:r},i?i.call(t,"apps/_form",o):u.call(t,"partial","apps/_form",o)))),r.buffer.push("\n\n"),l})}),define("ui/templates/apps/new",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var i,o,l="",u=a.helperMissing,p=this.escapeExpression;return r.buffer.push('<div class="page-header">\n  <h1>Register Application</h1>\n</div>\n\n'),r.buffer.push(p((i=a.partial||t&&t.partial,o={hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["STRING"],data:r},i?i.call(t,"apps/_form",o):u.call(t,"partial","apps/_form",o)))),r.buffer.push("\n"),l})}),define("ui/templates/apps/show",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){var s,n,r,i="";return t.buffer.push('\n  <div class="page-header">\n    <h1>'),s=a._triageMustache.call(e,"app.name",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),(s||0===s)&&t.buffer.push(s),t.buffer.push('</h1>\n  </div>\n\n  <div role="tabpanel">\n    <ul class="nav nav-tabs" role="tablist">\n      <li role="presentation" class="active"><a href="#info" role="tab" data-toggle="tab">Info</a></li>\n      <li role="presentation"><a href="#install" role="tab" data-toggle="tab">Install</a></li>\n    </ul>\n\n    <div class="tab-content">\n      <div role="tabpanel" class="tab-pane active" id="info">\n        <div>&nbsp;</div>\n        '),t.buffer.push(h((n=a.partial||e&&e.partial,r={hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["STRING"],data:t},n?n.call(e,"apps/info",r):p.call(e,"partial","apps/info",r)))),t.buffer.push('\n      </div>\n      <div role="tabpanel" class="tab-pane" id="install">\n        <div>&nbsp;</div>\n        '),t.buffer.push(h((n=a.partial||e&&e.partial,r={hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["STRING"],data:t},n?n.call(e,"apps/install",r):p.call(e,"partial","apps/install",r)))),t.buffer.push("\n      </div>\n    </div>\n  </div>\n\n"),i}function o(e,t){var s,n,r,i="";return t.buffer.push('\n  <div class="page-header">\n    <h1>'),s=a._triageMustache.call(e,"app.name",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),(s||0===s)&&t.buffer.push(s),t.buffer.push(" - Installation</h1>\n  </div>\n  "),t.buffer.push(h((n=a.partial||e&&e.partial,r={hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["STRING"],data:t},n?n.call(e,"apps/install",r):p.call(e,"partial","apps/install",r)))),t.buffer.push("\n"),i}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var l,u="",p=a.helperMissing,h=this.escapeExpression,f=this;return l=a["if"].call(t,"app.requests.total.count",{hash:{},hashTypes:{},hashContexts:{},inverse:f.program(3,o,r),fn:f.program(1,i,r),contexts:[t],types:["ID"],data:r}),(l||0===l)&&r.buffer.push(l),r.buffer.push("\n\n"),u})}),define("ui/templates/dashboard",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){t.buffer.push("Register App")}function o(e,t){var s,n,r,i="";return t.buffer.push('\n    <div class="col-md-3 app-slot">\n      <h4>\n        '),n=a["link-to"]||e&&e["link-to"],r={hash:{},hashTypes:{},hashContexts:{},inverse:g.noop,fn:g.program(4,l,t),contexts:[e,e],types:["STRING","ID"],data:t},s=n?n.call(e,"apps/show","app.id",r):y.call(e,"link-to","apps/show","app.id",r),(s||0===s)&&t.buffer.push(s),t.buffer.push('\n        <small class="pull-right">\n          '),n=a["link-to"]||e&&e["link-to"],r={hash:{},hashTypes:{},hashContexts:{},inverse:g.noop,fn:g.program(6,u,t),contexts:[e,e],types:["STRING","ID"],data:t},s=n?n.call(e,"apps/edit","app",r):y.call(e,"link-to","apps/edit","app",r),(s||0===s)&&t.buffer.push(s),t.buffer.push('\n          <a href="#" '),t.buffer.push(T(a.action.call(e,"destroy","app",{hash:{},hashTypes:{},hashContexts:{},contexts:[e,e],types:["STRING","ID"],data:t}))),t.buffer.push('><span class="glyphicon glyphicon-trash"></span></a>\n        </small>\n      </h4>\n      <table class="table table-striped">\n        <tr>\n          <th colspan="2">Requests</th>\n        </tr>\n        <tr>\n          <td>\n            <b>Today</b><br>\n            '),s=a["if"].call(e,"app.requests.today",{hash:{},hashTypes:{},hashContexts:{},inverse:g.program(10,h,t),fn:g.program(8,p,t),contexts:[e],types:["ID"],data:t}),(s||0===s)&&t.buffer.push(s),t.buffer.push('\n          </td>\n          <td class="yesterday">\n            <b>Yesterday</b><br>\n            '),s=a["if"].call(e,"app.requests.yesterday",{hash:{},hashTypes:{},hashContexts:{},inverse:g.program(10,h,t),fn:g.program(12,f,t),contexts:[e],types:["ID"],data:t}),(s||0===s)&&t.buffer.push(s),t.buffer.push("\n          </td>\n        </tr>\n      </table>\n    </div>\n  "),i}function l(e,t){var s;s=a._triageMustache.call(e,"app.name",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),t.buffer.push(s||0===s?s:"")}function u(e,t){t.buffer.push('<span class="glyphicon glyphicon-pencil"></span>')}function p(e,t){var s;s=a._triageMustache.call(e,"app.requests.today.count",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),t.buffer.push(s||0===s?s:"")}function h(e,t){t.buffer.push("-")}function f(e,t){var s;s=a._triageMustache.call(e,"app.requests.yesterday.count",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),t.buffer.push(s||0===s?s:"")}function c(e,t){var s,n,r,i="";return t.buffer.push('\n    <div>&nbsp;</div>\n    <h1 class="text-center">\n      You don\'t track any app yet, '),n=a["link-to"]||e&&e["link-to"],r={hash:{},hashTypes:{},hashContexts:{},inverse:g.noop,fn:g.program(15,d,t),contexts:[e],types:["STRING"],data:t},s=n?n.call(e,"apps/new",r):y.call(e,"link-to","apps/new",r),(s||0===s)&&t.buffer.push(s),t.buffer.push(".\n    </h1>\n  "),i}function d(e,t){t.buffer.push("register one")}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var b,m,v,x="",g=this,y=a.helperMissing,T=this.escapeExpression;return r.buffer.push('<div class="row-fluid text-right">\n  '),m=a["link-to"]||t&&t["link-to"],v={hash:{"class":"btn btn-default"},hashTypes:{"class":"STRING"},hashContexts:{"class":t},inverse:g.noop,fn:g.program(1,i,r),contexts:[t],types:["STRING"],data:r},b=m?m.call(t,"apps/new",v):y.call(t,"link-to","apps/new",v),(b||0===b)&&r.buffer.push(b),r.buffer.push('\n</div>\n\n<div class="row-fluid dashboard">\n  '),b=a.each.call(t,"app","in","apps",{hash:{},hashTypes:{},hashContexts:{},inverse:g.program(14,c,r),fn:g.program(3,o,r),contexts:[t,t,t],types:["ID","ID","ID"],data:r}),(b||0===b)&&r.buffer.push(b),r.buffer.push("\n</div>\n"),x})}),define("ui/templates/login",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){function i(e,t){var s,n="";return t.buffer.push('\n  <div class="alert alert-danger">\n    '),s=a._triageMustache.call(e,"errorMessage",{hash:{},hashTypes:{},hashContexts:{},contexts:[e],types:["ID"],data:t}),(s||0===s)&&t.buffer.push(s),t.buffer.push("\n  </div>\n"),n}this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var o,l,u,p="",h=this,f=this.escapeExpression,c=a.helperMissing;return r.buffer.push('<div class="page-header">\n  <h1>SnowmanIO</h1>\n</div>\n\n'),o=a["if"].call(t,"errorMessage",{hash:{},hashTypes:{},hashContexts:{},inverse:h.noop,fn:h.program(1,i,r),contexts:[t],types:["ID"],data:r}),(o||0===o)&&r.buffer.push(o),r.buffer.push('\n\n<div class="col-sm-6">\n  <form '),r.buffer.push(f(a.action.call(t,"authenticate",{hash:{on:"submit"},hashTypes:{on:"STRING"},hashContexts:{on:t},contexts:[t],types:["STRING"],data:r}))),r.buffer.push(' role="form">\n    <div class="form-group">\n      <label for=identification>Email</label>\n      '),r.buffer.push(f((l=a.input||t&&t.input,u={hash:{id:"identification","class":"form-control",value:"identification"},hashTypes:{id:"STRING","class":"STRING",value:"ID"},hashContexts:{id:t,"class":t,value:t},contexts:[],types:[],data:r},l?l.call(t,u):c.call(t,"input",u)))),r.buffer.push("\n      <br>\n      <label for=password>Password</label>\n      "),r.buffer.push(f((l=a.input||t&&t.input,u={hash:{id:"password","class":"form-control",type:"password",value:"password"},hashTypes:{id:"STRING","class":"STRING",type:"STRING",value:"ID"},hashContexts:{id:t,"class":t,type:t,value:t},contexts:[],types:[],data:r},l?l.call(t,u):c.call(t,"input",u)))),r.buffer.push('\n    </div>\n    <input type=submit value="Login" class="btn btn-default">\n  </form>\n</div>\n'),p})}),define("ui/templates/settings",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var i,o="";return r.buffer.push("<h2>SnowmanIO <small>"),i=a._triageMustache.call(t,"version",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push("</small></h2>\n\n<p>\n  <b>Base url:</b> "),i=a._triageMustache.call(t,"base_url",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push("\n</p>\n\n<p>\n  <b>Report recipients:</b> "),i=a._triageMustache.call(t,"report_recipients",{hash:{},hashTypes:{},hashContexts:{},contexts:[t],types:["ID"],data:r}),(i||0===i)&&r.buffer.push(i),r.buffer.push("\n</p>\n"),o})}),define("ui/templates/unpacking",["ember","exports"],function(e,t){"use strict";var s=e["default"];t["default"]=s.Handlebars.template(function(e,t,a,n,r){this.compilerInfo=[4,">= 1.0.0"],a=this.merge(a,s.Handlebars.helpers),r=r||{};var i,o,l="",u=this.escapeExpression,p=a.helperMissing;return r.buffer.push('<div class="page-header">\n  <h1>SnowmanIO: Installation</h1>\n</div>\n\n<div class="col-sm-6">\n  <form '),r.buffer.push(u(a.action.call(t,"setup",{hash:{on:"submit"},hashTypes:{on:"STRING"},hashContexts:{on:t},contexts:[t],types:["STRING"],data:r}))),r.buffer.push(' role="form">\n    <div class="form-group">\n      <label for=email>Email</label>\n      '),r.buffer.push(u((i=a.input||t&&t.input,o={hash:{id:"email","class":"form-control",value:"email"},hashTypes:{id:"STRING","class":"STRING",value:"ID"},hashContexts:{id:t,"class":t,value:t},contexts:[],types:[],data:r},i?i.call(t,o):p.call(t,"input",o)))),r.buffer.push("\n      <br>\n      <label for=password>Password</label>\n      "),r.buffer.push(u((i=a.input||t&&t.input,o={hash:{id:"password","class":"form-control",type:"password",value:"password"},hashTypes:{id:"STRING","class":"STRING",type:"STRING",value:"ID"},hashContexts:{id:t,"class":t,type:t,value:t},contexts:[],types:[],data:r},i?i.call(t,o):p.call(t,"input",o)))),r.buffer.push('\n    </div>\n    <input type=submit value="Login" class="btn btn-default">\n  </form>\n</div>\n'),l})}),define("ui/config/environment",["ember"],function(e){var t="ui";try{var s=t+"/config/environment",a=e["default"].$('meta[name="'+s+'"]').attr("content"),n=JSON.parse(unescape(a));return{"default":n}}catch(r){throw new Error('Could not read config from meta tag with name "'+s+'".')}}),runningTests?require("ui/tests/test-helper"):require("ui/app")["default"].create({});