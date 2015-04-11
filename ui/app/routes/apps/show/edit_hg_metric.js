import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find("hgMetric", params.hg_metric_id);
  },

  setupController: function(controller, model) {
    this._super(controller, model);
    controller.resetForm();
    var app = this.modelFor("apps/show");
    controller.set("app", app);
  }
});
