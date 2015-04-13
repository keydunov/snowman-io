import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord("hg-metric");
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set("app", this.modelFor("apps.show"));
  },

  deactivate: function() {
    if (this.controller.get("model.isNew")) {
      this.controller.get("model").rollback();
    }
  }
});
