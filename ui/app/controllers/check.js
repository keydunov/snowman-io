import Ember from 'ember';
import config from '../config/environment';

export default Ember.Controller.extend({
  actions: {
    resolve: function() {
      var me = this;
      this.set("resolveInProgress", true);
      Ember.$.ajax({
        url: String(config.baseHost) + "/api/checks/" + me.get("model").get("id") + "/resolve",
        type: "POST",
        data: JSON.stringify({})
      }).then(function() {
        me.get('model').reload().then(function() {
          me.set("resolveInProgress", false);
        });
      });
    }
  }
});
