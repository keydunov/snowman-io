import DS from 'ember-data';

export default DS.Model.extend({
  kind: DS.attr('string'),

  // kind: HG
  hgMetric: DS.attr('string')
});
