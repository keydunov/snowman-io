import Ember from 'ember';

export default Ember.Controller.extend({
  reset: function() {
    this.set("name", this.get("model.name"));
  }.on('init'),

  isFormValid: function() {
    return Ember.isPresent(this.get("name"));
  }.property("name"),
  isFormInvalid: Ember.computed.not("isFormValid"),

  actions: {
    save: function() {
      this.set("model.name", this.get("name"));
      return true;
    }
  }
});
