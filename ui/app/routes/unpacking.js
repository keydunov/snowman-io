import Ember from 'ember';
import NotAuthenticatedRouteMixin from '../mixins/not-authenticated-route-mixin';

export default Ember.Route.extend(NotAuthenticatedRouteMixin, {
  model: function() {
    return this.store.createRecord('user');
  },

  deactivate: function() {
    if (this.controller.get("model.isNew")) {
      this.controller.get("model").rollback();
    }
  }
});
