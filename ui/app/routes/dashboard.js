import Ember from 'ember';
import LivePooling from '../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function() {
    return Ember.RSVP.hash({
      apps: this.store.find('app')
    });
  },

  onPoll: function() {
    this.refresh();
  }
});
