import Ember from 'ember';
import AuthenticatedRouteMixin from 'simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  model: function() {
    return Ember.$.get(this._infoUrl());
  },

  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  },

  // regular polling of key models (idea from http://yoranbrondsema.com/live-polling-system-ember-js/)
  activate: function() {
    this.set("timer", this._schedule());
  },

  deactivate: function() {
    Ember.run.cancel(this.get("timer"));
  },

  _schedule: function() {
    return Ember.run.later(this, function() {
      this._tick();
      this.set("timer", this._schedule());
    }, 5000);
  },

  _tick: function() {
    this._update("app");
    this._update("metric");
    this._update("check");
  },

  _update: function(modelName) {
    var adapter = this.container.lookup('adapter:application');
    var inflector = new Ember.Inflector(Ember.Inflector.defaultRules);
    var me = this;
    var last = this.get("last_" + modelName) || 0;

    Ember.$.getJSON(adapter.buildURL(modelName) + "?last=" + last).then(function(data) {
      Ember.run.next(me, function() {
        // console.log(data, inflector.pluralize(modelName));
        me.set("last_" + modelName, data.last);
        // new & updates
        Ember.$.each(data[inflector.pluralize(modelName)], function() {
          me.store.push(modelName, me.store.normalize(modelName, this));
        });
        // deletes
        Ember.$.each(data.deleted, function() {
          var record = me.store.getById(modelName, this);
          if (record) {
            record.deleteRecord();
          }
        });
      });
    });
  },
});
