import DS from 'ember-data';

export default DS.Model.extend({
  status: DS.attr('string'),
  positive_count: DS.attr('number'),
  fail_count: DS.attr('number'),
  raw_history: DS.attr('string'),

  history: function() {
    return JSON.parse(this.get("raw_history"));
  }.property("raw_history"),
  
  isFailed: function() {
    return this.get("status") === 'failed';
  }.property("status")
});
