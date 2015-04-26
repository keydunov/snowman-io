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
        this.resource('metrics', function() {
          this.route('new');
          this.route('show', {path: ':metric_id'});
          this.route('edit', {path: ':metric_id/edit'});
        });
        this.resource('checks');
      });
    });
  });
});

export default Router;
