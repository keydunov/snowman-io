import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  token: DS.attr('string'),

  isNameEmpty: Ember.computed.empty('name'),

  // Rails app
  requestsJSON: DS.attr('string'),

  requests: function () {
    return JSON.parse(this.get("requestsJSON"));
  }.property("requestsJSON")
});
