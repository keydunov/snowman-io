import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.modelFor("apps/show");
  },

  actions: {
    save: function() {
      var me = this;
      var app = this.modelFor("apps/show");
      app.save().then(function() {
        me.transitionTo("apps.show.info", app);
      });
    }
  }
});
