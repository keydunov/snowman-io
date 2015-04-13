import Ember from 'ember';

export default Ember.Controller.extend({
  isFormValid: function() {
    return !this.get("saving") && Ember.isPresent(this.get("model.name")) && Ember.isPresent(this.get("model.metricName"));
  }.property("model.name", "model.metricName", "saving"),

  actions: {
    submit: function() {
      var me = this;
      var app = this.get("app");
      var metric = this.get("model");
      me.set("saving", true);
      metric.save().then(function() {
        me.set("saving", false);
        me.transitionToRoute("hg_metrics.show", app, metric);
      });
    }
  }
});
