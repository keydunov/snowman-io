import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return Ember.RSVP.hash({
      app: this.store.fetch('app', params.id),
      info: Ember.$.get(this._infoUrl())
    });
  },

  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  }
});
