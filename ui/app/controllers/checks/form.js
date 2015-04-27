import Ember from 'ember';

export default Ember.Controller.extend({
  reset: function() {
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
      this.set("model.cmp", this.get("cmp"));
      this.set("model.value", this.get("value"));
      return true;
    },
  }
});
