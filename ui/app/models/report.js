import DS from 'ember-data';

export default DS.Model.extend({
  key: DS.attr('number'),
  body: DS.attr('string'),
  at: DS.attr('date')
});
