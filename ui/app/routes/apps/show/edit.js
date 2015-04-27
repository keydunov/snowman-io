import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.modelFor("apps/show");
  },

  actions: {
    save: function() {
      var me = this;
      var app = this.controller.get("model");
      app.save().then(function() {
        me.transitionTo("apps.show.info", app);
      });
    }
  }
});
