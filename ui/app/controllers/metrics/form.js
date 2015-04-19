import Ember from 'ember';

export default Ember.Controller.extend({
  isFormValid: function() {
    return !this.get("saving") && Ember.isPresent(this.get("model.name")) && Ember.isPresent(this.get("model.metricName"));
  }.property("model.name", "model.metricName", "saving"),
});
