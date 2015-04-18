import Ember from 'ember';

export default Ember.Controller.extend({
  isFormValid: function() {
    return Ember.isPresent(this.get("appName"));
  }.property("appName"),
  isFormInvalid: Ember.computed.not("isFormValid"),

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
