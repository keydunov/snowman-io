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
      this.set("editing", false);
    },
  }
});
