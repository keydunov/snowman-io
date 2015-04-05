import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('app', params.id);
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set("fixedName", model.get("name"));
  },

  deactivate: function() {
    if (this.controller.get("model.isDirty")) {
      this.controller.get("model").rollback();
    }
  }
});
