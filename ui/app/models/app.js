import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  token: DS.attr('string'),

  hgMetrics: DS.hasMany('hg-metric', { async: true }),

  // Rails app
  requestsJSON: DS.attr('string'),

  // Computed
  isNameEmpty: Ember.computed.empty('name'),
  requests: function () {
    return JSON.parse(this.get("requestsJSON"));
  }.property("requestsJSON"),

  isInitiated: function() {
    return this.get("requests").total.count > 0 || this.get("hgMetrics.length");
  }.property("requests", "hgMetrics"),

  hgMetricsAmountHuman: function() {
    var amount = this.get("hgMetrics.length");
    return amount + " HG Metric" + (amount > 1 ? "s" : "");
  }.property("hgMetrics")
});
