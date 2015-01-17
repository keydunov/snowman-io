import DS from 'ember-data';

export default DS.Model.extend({
  key: DS.attr('string'),
  report: DS.attr('string'),

  parsedReport: function() {
    return JSON.parse(this.get("report"));
  }.property("report")
});
