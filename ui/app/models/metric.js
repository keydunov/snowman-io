import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  app: DS.belongsTo('app'),
  checks: DS.hasMany('check', { async: true }),

  name: DS.attr('string'),
  source: DS.attr('string'),
  kind: DS.attr('string'),

  // source: hg
  metricName: DS.attr('string'),

  isDeploy: Ember.computed.equal("kind", "deploy"),
  isEditable: function() {
    return this.get("isSourceHg");
  }.property("source"),

  isSourceHg: Ember.computed.equal("source", "hg"),

  triggeredChecks: Ember.computed.filterBy('checks', 'triggered', true),
});
