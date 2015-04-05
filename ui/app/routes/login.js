import Ember from 'ember';
import NotAuthenticatedRouteMixin from '../mixins/not-authenticated-route-mixin';

export default Ember.Route.extend(NotAuthenticatedRouteMixin, {
  setupController: function(controller) {
    controller.set('errorMessage', null);
  }
});
