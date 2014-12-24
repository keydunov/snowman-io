import Ember from 'ember';
import config from '../config/environment';

export default Ember.Controller.extend({
  actions: {
    resolve: function() {
      this.set("resolveInProgress", true);
      var me = this;

      this.get("model").resolve().then(function() {
        me.get('model').reload().then(function() {
          me.set("resolveInProgress", false);
        });
      });
    }
  }
});
