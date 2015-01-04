import Ember from 'ember';

export default Ember.ArrayController.extend({
  persisted: function() {
    return this.get("model").filter(function(collector) {
      return !collector.get('isNew');
    });
  }.property("model.@each.isNew")
});
