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
      this.route('show', {path: 'apps/:id'}, function() {
        this.route('info');
        this.route('install');
        this.route('add_hg_metric');
      });
      this.route('edit', {path: 'apps/:id/edit'});
    });
  });
});

export default Router;
