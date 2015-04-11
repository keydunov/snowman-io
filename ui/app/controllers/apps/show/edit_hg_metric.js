import Ember from 'ember';

export default Ember.Controller.extend({
  resetForm: function() {
    this.set("hgName", this.get("model.name"));
    this.set("hgMetricName", this.get("model.metricName"));
    this.set("hgKind", this.get("model.kind"));
  },

  hgKinds: ["time", "counter", "amount", "deploy"],

  hgFormValid: function() {
    return !this.get("hgSaving") && Ember.isPresent(this.get("hgName")) && Ember.isPresent(this.get("hgMetricName"));
  }.property("hgName", "hgMetricName", "hgSaving"),

  actions: {
    hgSubmit: function() {
      var me = this;
      var app = this.get("app");
      var metric = this.get("model");
      metric.set("name", this.get("hgName"));
      metric.set("metricName", this.get("hgMetricName"));
      metric.set("kind", this.get("hgKind"));
      me.set("hgSaving", true);
      metric.save().then(function() {
        me.set("hgSaving", false);
        me.transitionToRoute("apps.show.info", app);
      });
    }
  }
});
