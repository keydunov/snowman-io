import Ember from 'ember';

export default Ember.Controller.extend({
  version: function() {
     return $('meta[name=snowman-io-version]').attr("content")
  }.property()
});
