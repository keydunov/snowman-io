import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.find('app');
  },

  // regular polling of apps (idea from http://yoranbrondsema.com/live-polling-system-ember-js/)
  activate: function() {
    this.set("timer", this._schedule());
  },

  deactivate: function() {
    Ember.run.cancel(this.get("timer"));
    this.set("timer", null);
  },

  _schedule: function() {
    return Ember.run.later(this, function() {
      this._tick();
      this.set("timer", this._schedule());
    }, 3000);
  },

  _tick: function() {
    var adapter = this.container.lookup('adapter:application');
    var me = this;
    Ember.$.getJSON(adapter.buildURL("app")).then(function(data) {
      Ember.run.next(me, function() {
        Ember.$.each(data.apps, function() {
          me.store.push("app", this);
        });
      });
    });
  }
});
