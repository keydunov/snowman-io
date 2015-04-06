import Ember from 'ember';

export default Ember.ObjectController.extend({
  needs: ["snow"],
  base_url: Ember.computed.alias("controllers.snow.model.base_url"),

  hasRequests: function() {
    return this.get("requests.today") && this.get("requests.yesterday");
  }.property("requests.today", "requests.yesterday")
});
