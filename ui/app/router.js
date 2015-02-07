import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('dashboard', {path: '/'});
  this.route('settings');

  this.route('apps/new', {path: '/apps/new'});
  this.route('apps/edit', {path: '/apps/:id/edit'});

  // this.route('apps/index', {path: '/apps'});
  // this.route('apps/show', {path: '/apps/:id'});
  //
  // this.route('metrics/index', {path: '/metrics'});
  // this.route('metrics/show', {path: '/metrics/:id'});
  //
  // this.route('reports/index', {path: '/reports'});
  // this.route('reports/show', {path: '/reports/:id'});
});

export default Router;
