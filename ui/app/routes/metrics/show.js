import Ember from 'ember';
import LivePooling from '../../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function(params) {
    return this.store.find('metric', params.id);
  },

  onPoll: function() {
    this.controller.get("model").reload();
  }
});
