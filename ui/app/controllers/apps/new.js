import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["apps/form"],
  appName: Ember.computed.alias("controllers.apps/form.appName"),

  actions: {
    save: function() {
      var me = this;
      var app = this.store.createRecord("app", {name: this.get("appName")});

      app.save().then(function() {
        me.transitionToRoute("apps.show.info", app);
      });
    }
  }
});
