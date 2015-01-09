var EmberApp = require('ember-cli/lib/broccoli/ember-app');
var app = new EmberApp();

// Bootstrap
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

// MetricsGraphics.js
app.import("vendor/d3/d3.js");
app.import("vendor/metrics-graphics-2.0.0/dist/metricsgraphics.js");
app.import("vendor/metrics-graphics-2.0.0/dist/metricsgraphics.css");

module.exports = app.toTree();
