import Ember from 'ember';
import LoginControllerMixin from 'simple-auth/mixins/login-controller-mixin';

export default Ember.Controller.extend(LoginControllerMixin, {
  authenticator: 'simple-auth-authenticator:devise',
  actions: {
    // display an error when authentication fails
    authenticate: function() {
      var _this = this;
      this._super().then(null, function(error) {
        _this.set('errorMessage', error.message);
      });
    }
  }
});
