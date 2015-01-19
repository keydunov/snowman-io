import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  last_value: DS.attr('number'),
  points_5min_json: DS.attr('string'),

  points_5min: function() {
    return JSON.parse(this.get("points_5min_json"));
  }.property("points_5min_json")
});
