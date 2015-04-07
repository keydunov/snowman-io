import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    setup: function() {
      var me    = this;
      var model = this.model;

      model.save().then(function() {
        var authOptions = { identification: model.get("email"), password: model.get("password") };
        me.get("session").authenticate('simple-auth-authenticator:devise', authOptions).then(function() {
          me.transitionToRoute("apps");
        });
      });
    }
  }
});
