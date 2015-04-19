import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find("metric", params.metric_id);
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set("app", this.modelFor("apps.show"));
  }
});
