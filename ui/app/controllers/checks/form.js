import Ember from 'ember';

export default Ember.Controller.extend({
  resetForm: function() {
    this.set("metricName", this.get("model.metric.name"));
    this.set("cmp", this.get("model.cmp"));
    this.set("value", this.get("model.value"));
  }.on("init"),

  actions: {
    clickMore: function() {
      this.set("cmp", "more");
    },

    clickLess: function() {
      this.set("cmp", "less");
    },

    save: function() {
      var me = this;
      this.model.set("cmp", this.get("cmp"));
      this.model.set("value", this.get("value"));
      this.model.save();
      return true;
    },
  }
});
