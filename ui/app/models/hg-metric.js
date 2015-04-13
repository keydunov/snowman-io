import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  app: DS.belongsTo('app'),

  name: DS.attr('string'),
  metricName: DS.attr('string'),
  kind: DS.attr('string'),

  availableKinds: ["time", "counter", "amount", "deploy"],

  isDeploy: Ember.computed.equal("kind", "deploy")
});
