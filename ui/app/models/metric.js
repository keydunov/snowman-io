import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  last_value: DS.attr('number'),
  todayCount: DS.attr('number'),
  lastValueHuman: DS.attr('string'),
  trendJSON: DS.attr('string'),

  trend: function () {
    return JSON.parse(this.get("trendJSON"));
  }.property("trendJSON")
});
