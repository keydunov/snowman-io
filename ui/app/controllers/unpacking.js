import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    setup: function() {
      var _this = this;
      var user = this.get("model");
      user.save().then(function() {
        var authOptions = { identification: user.get("email"), password: user.get("password") };
        _this.get("session").authenticate('simple-auth-authenticator:devise', authOptions).then(function() {
          _this.transitionToRoute("apps");
        });
      });
    }
  }
});
