import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return Ember.Object.create({
      isNew: true,
      name: "",
      metricName: "",
      source: "hg",
      kind: "time"
    });
  },

  actions: {
    save: function() {
      var me = this;
      var app = this.modelFor("apps/show");

      var metric = this.store.createRecord("metric", {
        name: this.controller.get("model.name"),
        source: this.controller.get("model.source"),
        metricName: this.controller.get("model.metricName"),
        kind: this.controller.get("model.kind")
      });

      app.get("metrics").pushObject(metric);
      metric.save().then(function() {
        me.transitionTo("metrics.show", app, metric);
      });
    }
  }
});
