import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('dashboard', {path: '/'});
  this.route('settings');

  this.route('apps/new', {path: '/apps/new'});
  this.route('apps/show', {path: '/apps/:id'});
  this.route('apps/edit', {path: '/apps/:id/edit'});
});

export default Router;
