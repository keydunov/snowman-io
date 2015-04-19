import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  token: DS.attr('string'),

  metrics: DS.hasMany('metric', { async: true }),

  // Rails app
  requestsJSON: DS.attr('string'),

  // Computed
  isNameEmpty: Ember.computed.empty('name'),
  requests: function () {
    return JSON.parse(this.get("requestsJSON"));
  }.property("requestsJSON"),

  isInitiated: function() {
    return this.get("requests").total.count > 0 || this.get("metrics.length");
  }.property("requests", "metrics"),

  metricsAmountHuman: function() {
    var amount = this.get("metrics.length");
    return amount + " Metric" + (amount !== 1 ? "s" : "");
  }.property("metrics"),

  hgDeployMetric: function() {
    return this.get("hgMetrics").find(function(hgMetric){
      return hgMetric.get("kind") === "deploy";
    });
  }.property("metrics.@each.kind")
});
