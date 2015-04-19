import Ember from 'ember';

export default Ember.Controller.extend({
  isFormValid: function() {
    return Ember.isPresent(this.get("appName"));
  }.property("appName"),
  isFormInvalid: Ember.computed.not("isFormValid"),
});
