import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  base_url: Ember.computed.alias("controllers.snow.model.base_url"),

  hasRequests: function() {
    return this.get("model.requests.today") && this.get("model.requests.yesterday");
  }.property("model.requests.today", "model.requests.yesterday")
});
