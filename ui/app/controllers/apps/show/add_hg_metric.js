import Ember from 'ember';

export default Ember.Controller.extend({
  // needs: ["snow"],
  // baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  // hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  // isHgEnabled: Ember.computed.equal("hgStatus", "enabled"),

  // hasRequests: function() {
  //   return this.get("model.requests.today") && this.get("model.requests.yesterday");
  // }.property("model.requests.today", "model.requests.yesterday"),
  //
  hgKinds: ["time", "counter", "amount", "deploy"],

  hgFormValid: function() {
    return !this.get("hgSaving") && Ember.isPresent(this.get("hgName")) && Ember.isPresent(this.get("hgMetricName"));
  }.property("hgName", "hgMetricName", "hgSaving"),

  actions: {
    hgSubmit: function() {
      var me = this;
      var app = this.get("model");
      var metric = this.store.createRecord("hg-metric", {
        name: this.get("hgName"),
        metricName: this.get("hgMetricName"),
        kind: this.get("hgKind")
      });
      app.get("hgMetrics").pushObject(metric);
      me.set("hgSaving", true);
      metric.save().then(function() {
        me.set("hgSaving", false);
        me.transitionToRoute("apps.show.info", app);
      });
    }
  }
});
