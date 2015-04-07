import Ember from 'ember';

export default Ember.ObjectController.extend({
  needs: ["snow"],
  baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  isHgEnabled: Ember.computed.equal("hgStatus", "enabled"),

  hasRequests: function() {
    return this.get("requests.today") && this.get("requests.yesterday");
  }.property("requests.today", "requests.yesterday"),

  hgKinds: ["time", "counter", "amount", "deploy"],

  hgFormValid: function() {
    return !this.get("hgSaving") && Ember.isPresent(this.get("hgName")) && Ember.isPresent(this.get("hgMetricName"));
  }.property("hgName", "hgMetricName", "hgSaving"),

  actions: {
    hgSubmit: function() {
      var me = this;
      var app = this.get("model");
      var metric = this.store.createRecord("hgMetric", {
        name: this.get("hgName"),
        metricName: this.get("hgMetricName"),
        kind: this.get("hgKind")
      });
      app.get("hgMetrics").pushObject(metric);
      me.set("hgSaving", true);
      metric.save().then(function() {
        me.set("hgSaving", false);
        $('.nav-tabs a[href="#info"]').tab('show');
      });
    }
  }
});
