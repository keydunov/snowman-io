import Ember from 'ember';

export default Ember.ObjectController.extend({
  version: function() {
     return Ember.$('meta[name=snowman-io-version]').attr("content");
  }.property()
});
