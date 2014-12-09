import DS from 'ember-data';

export default DS.Model.extend({
  count: DS.attr('number'),
  status: DS.attr('string'),
  
  isFailed: function() {
    return this.get("status") == 'failed';
  }.property("status")
});
