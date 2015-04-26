import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return Ember.Object.create({isNew: true, name: ""});
  },

  actions: {
    save: function() {
      var me = this;
      var app = this.store.createRecord("app", {name: this.modelFor("apps/new").get("name")});

      app.save().then(function() {
        me.transitionTo("apps.show.info", app);
      });
    }
  }
});
