import Ember from 'ember';

export default Ember.Controller.extend({
  saving: false,
  availableKinds: ["time", "counter", "amount", "deploy"],

  reset: function() {
    this.set("name", this.get("model.name"));
    this.set("metricName", this.get("model.metricName"));
    this.set("kind", this.get("model.kind"));
  }.on("init"),

  isFormValid: function() {
    return Ember.isPresent(this.get("name")) && Ember.isPresent(this.get("metricName")) && !this.get("saving");
  }.property("name", "metricName", "saving"),

  actions: {
    save: function() {
      this.set("saving", true);
      this.set("model.name", this.get("name"));
      this.set("model.metricName", this.get("metricName"));
      this.set("model.kind", this.get("kind"));
      return true;
    }
  }
});
