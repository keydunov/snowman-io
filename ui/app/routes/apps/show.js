import Ember from 'ember';
import LivePooling from '../../mixins/live-pooling';

export default Ember.Route.extend(LivePooling, {
  model: function(params) {
    return Ember.RSVP.hash({
      app: this.store.fetch('app', params.id),
      info: Ember.$.get(this._infoUrl())
    });
  },

  onPoll: function() {
    this.refresh();
  },

  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  }
});
