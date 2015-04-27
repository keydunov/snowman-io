import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find("metric", params.metric_id);
  },

  actions: {
    save: function() {
      var me = this;
      var app = this.modelFor("apps/show");
      var metric = this.controller.get("model");

      metric.save().then(function() {
        me.transitionTo("metrics.show", app, metric);
      });
    }
  }
});
