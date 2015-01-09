import DS from 'ember-data';

export default DS.Model.extend({
  at: DS.attr('date'),
  value: DS.attr('number')
});
