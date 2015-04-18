import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('unpacking');
  this.route('login');

  this.resource('snow', {path: '/'}, function() {
    this.route('settings');

    this.resource('apps', {path: '/'}, function() {
      this.route('new', {path: 'apps/new'});
      this.route('show', {path: 'apps/:app_id'}, function() {
        this.route('info');
        this.route('install');
        this.route('edit');
        this.resource('hg_metrics', function() {
          this.route('new');
          this.route('show', {path: ':hg_metric_id'});
          this.route('edit', {path: ':hg_metric_id/edit'});
        });
      });
    });
  });
});

export default Router;
