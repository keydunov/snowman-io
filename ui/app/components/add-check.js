import Ember from 'ember';

export default Ember.Component.extend({
  collapsed: true,

  actions: {
    add: function() {
      this.set("collapsed", false);
    },

    cancel: function() {
      this.set("collapsed", true);
    },
  }
});
