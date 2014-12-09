import Ember from 'ember';
import LivePooling from '../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function() {
    return this.store.find('check');
  },
  onPoll: function() {
    // TODO: reload all models by one request
    this.controller.get('model').forEach(function(record){
      record.reload();
    });
  }
});
