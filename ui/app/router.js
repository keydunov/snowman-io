import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('dashboard', {path: '/'});

  this.route('collectors/index', {path: '/collectors'});
  this.route('collectors/new', {path: '/collectors/new'});
  this.route('collectors/new_hg', {path: '/collectors/new/hg'});
  this.route('collectors/show', {path: '/collectors/:id'});
  this.route('collectors/edit', {path: '/collectors/:id/edit'});
  this.route('collectors/destroy', {path: '/collectors/:id/destroy'});

  this.route('metrics/index', {path: '/metrics'});

  this.route('about');
});

export default Router;
