import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  token: DS.attr('string'),

  hgMetrics: DS.hasMany('hgMetric', { async: true }),

  // Rails app
  requestsJSON: DS.attr('string'),

  // Computed
  isNameEmpty: Ember.computed.empty('name'),
  requests: function () {
    return JSON.parse(this.get("requestsJSON"));
  }.property("requestsJSON")
});
