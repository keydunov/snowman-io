import Session from 'simple-auth/session';
import Ember from 'ember';

// TODO: since ember-simple-auth 0.8.0
// user properties (toekn, email, id) will be wraped
// in 'secure' object.
export function initialize() {
  Session.reopen({
    setCurrentUser: function() {
      var id = this.get('user_id');
      var me = this;

      if (!Ember.isEmpty(id)) {
        return this.container.lookup('store:main').find('user', id)
          .then(function(user) {
            me.set("currentUser", user);
          });
      }
    }.observes("user_id")
  });
}

export default {
  name: 'custom-session',
  before: 'simple-auth',
  initialize: initialize
};
