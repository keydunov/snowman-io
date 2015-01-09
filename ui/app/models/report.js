import DS from 'ember-data';

export default DS.Model.extend({
  key: DS.attr('number'),
  rawReport: DS.attr('string'),
  at: DS.attr('date'),

  report: function() {
    return JSON.parse(this.get("rawReport"));
  }.property("rawReport")
});
