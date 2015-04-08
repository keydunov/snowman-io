var EmberApp = require('ember-cli/lib/broccoli/ember-app');
var app = new EmberApp();

// boostrap
app.import("vendor/bootstrap-3.3.1/css/bootstrap.css");
app.import("vendor/bootstrap-3.3.1/js/bootstrap.js");
var fonts = [
  "vendor/bootstrap-3.3.1/fonts/glyphicons-halflings-regular.eot",
  "vendor/bootstrap-3.3.1/fonts/glyphicons-halflings-regular.svg",
  "vendor/bootstrap-3.3.1/fonts/glyphicons-halflings-regular.ttf",
  "vendor/bootstrap-3.3.1/fonts/glyphicons-halflings-regular.woff"
];
fonts.forEach(function(font) {
  app.import(font, {destDir: "fonts"});
});

module.exports = app.toTree();
