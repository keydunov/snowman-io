import Ember from 'ember';
import config from '../config/environment';

export default Ember.Object.extend({
  collectorAll: function() {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      Ember.$.ajax({
        url: config.baseHost + "/api/collectors",
        type: "GET",
        dataType: "json",
        success: function(data) {
          resolve(data.collectors);
        },
        // TODO: think about more correct implementation of rejection
        reject: function() {
          reject();
        }
      });
    });
  }
});
