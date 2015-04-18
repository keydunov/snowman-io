import Ember from 'ember';

export default Ember.Component.extend({
  isFormValid: function() {
    return Ember.isPresent(this.get("appName"));
  }.property("appName"),
  isFormInvalid: Ember.computed.not("isFormValid"),

  actions: {
    save: function() {
      this.sendAction();
    }
  }
});
