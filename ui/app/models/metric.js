import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  last_value: DS.attr('number')
});
