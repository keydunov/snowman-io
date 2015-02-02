import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  token: DS.attr('string'),

  // Rails app
  controllers: DS.attr('number'),
  models: DS.attr('number'),
  requestsJSON: DS.attr('string'),

  requests: function () {
    return JSON.parse(this.get("requestsJSON"));
  }.property("requestsJSON")
});
