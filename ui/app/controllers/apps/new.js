import Ember from 'ember';

export default Ember.Controller.extend({
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
