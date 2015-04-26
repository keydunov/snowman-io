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

  metricsAmountHuman: function() {
    var amount = this.get("metrics.length");
    return amount + " Metric" + (amount !== 1 ? "s" : "");
  }.property("metrics.length"),

  hgDeployMetric: function() {
    return this.get("metrics").find(function(metric){
      return metric.get("source") === "hg" && metric.get("kind") === "deploy";
    });
  }.property("metrics.@each.kind", "metrics.@each.source"),

  checks: function() {
    return this.get("metrics").then(function(metrics) {
      return metrics.mapBy("checks");
    });
  }.property("metrics.@each.checks")
});
