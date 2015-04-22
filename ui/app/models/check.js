import DS from 'ember-data';

export default DS.Model.extend({
  metric: DS.belongsTo('metric'),
  triggered: DS.attr('boolean'),

  cmp: DS.attr('string'),
  value: DS.attr('number'),
});
