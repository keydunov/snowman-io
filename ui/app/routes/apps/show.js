import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return Ember.RSVP.hash({
      app: this.store.find('app', params.id),
      info: Ember.$.get(this._infoUrl())
    });
  },

  // TODO: organize code better (see routes/about.js)
  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  }
});
