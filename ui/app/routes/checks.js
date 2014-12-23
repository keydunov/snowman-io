import Ember from 'ember';
import LivePooling from '../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function() {
    return this.store.find('check');
  },
  onPoll: function() {
    this.refresh();
  }
});
