import Ember from 'ember';

export default Ember.Route.extend({
  activate: function() {
    this.controllerFor("apps").set("showMenu", true);
  },

  deactivate: function() {
    this.controllerFor("apps").set("showMenu", false);
  },

  model: function(params) {
    return this.store.find('app', params.id);
  }
});
