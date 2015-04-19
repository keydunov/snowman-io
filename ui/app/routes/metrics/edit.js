import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find("metric", params.metric_id);
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set("app", this.modelFor("apps.show"));
    controller.set("fixedName", model.get("name"));
  },

  deactivate: function() {
    if (this.controller.get("model.isDirty")) {
      this.controller.get("model").rollback();
    }
  }
});
