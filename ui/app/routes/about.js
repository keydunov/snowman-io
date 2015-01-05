import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return Ember.$.get(this._infoUrl());
  },

  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  }
});
