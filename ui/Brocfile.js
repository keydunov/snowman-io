var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({
  'ember-cli-bootstrap-sass': {
    'components': false,
    'importBootstrapJS': true
  }
});

module.exports = app.toTree();
