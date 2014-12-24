import DS from 'ember-data';

export default DS.Model.extend({
  status: DS.attr('string'),
  positive_count: DS.attr('number'),
  fail_count: DS.attr('number'),
  raw_history: DS.attr('string'),

  resolve: function() {
    return Ember.$.ajax({
      url: this._resolveUrl(),
      type: "POST",
      data: JSON.stringify({})
    });
  },

  _resolveUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL('checks', this.get('id')) + '/resolve'
  },

  history: function() {
    return JSON.parse(this.get("raw_history"));
  }.property("raw_history"),

  isFailed: function() {
    return this.get("status") === 'failed';
  }.property("status")
});
