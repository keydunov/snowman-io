import Ember from 'ember';

export default Ember.Controller.extend({
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
      var check;
      if (this.get("model.isNew")) {
        check = this.store.createRecord("check");
        this.get("model.metric.checks").pushObject(check);
      } else {
        check = this.get("model");
      }
      check.set("cmp", this.get("cmp"));
      check.set("value", this.get("value"));
      check.save();
      this.resetForm();
      return true;
    },
  }
});
