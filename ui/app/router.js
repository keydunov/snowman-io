import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('checks', { path: '/' });
  this.resource('check', { path: '/checks/:check_id' });
});

export default Router;
