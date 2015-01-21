import Ember from 'ember';
import LivePooling from '../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function() {
    return Ember.RSVP.hash({
      dashboard: Ember.$.get(this._url()),
      newMetrics: this.store.find('metric', {new: true})
    });
  },

  onPoll: function() {
    this.refresh();
  },

  _url: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/dashboard";
  }
});
