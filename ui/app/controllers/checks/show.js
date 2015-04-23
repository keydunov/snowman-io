import Ember from 'ember';

export default Ember.Controller.extend({
  reset: function() {
    this.set("editing", false);
  }.on("init"),

  actions: {
    edit: function() {
      this.set("editing", true);
    },

    cancel: function() {
      this.set("editing", false);
    },

    save: function() {
      var check = this.get("model");
      check.save();
      this.set("editing", false);
    },
  }
});
