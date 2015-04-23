import Ember from 'ember';

export default Ember.Controller.extend({
  needs: "metrics/show",
  metric: Ember.computed.alias("controllers.metrics/show.model"),

  resetForm: function() {
    this.set("cmp", this.get("model.cmp"));
    this.set("value", this.get("model.value"));
  }.on("init"),

  actions: {
    cancel: function() {
      this.resetForm();
      return true;
    },

    clickMore: function() {
      this.set("cmp", "more");
    },

    clickLess: function() {
      this.set("cmp", "less");
    },

    save: function() {
      var check = this.get("model");
      check.set("cmp", this.get("cmp"));
      check.set("value", this.get("value"));
      this.resetForm();
      return true;
    },
  }
});
