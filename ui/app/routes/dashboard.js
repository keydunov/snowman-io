import Ember from 'ember';
import LivePooling from '../mixins/live-pooling';
import AuthenticatedRouteMixin from 'simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(LivePooling, AuthenticatedRouteMixin, {
  model: function() {
    return Ember.RSVP.hash({
      apps: this.store.find('app')
    });
  },

  onPoll: function() {
    this.refresh();
  }
});
