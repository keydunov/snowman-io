import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('dashboard', {path: '/'});

  this.route('metrics/index', {path: '/metrics'});
  this.route('metrics/show', {path: '/metrics/:id'});

  this.route('reports/index', {path: '/reports'});
  this.route('reports/show', {path: '/reports/:id'});

  this.route('about');
});

export default Router;
