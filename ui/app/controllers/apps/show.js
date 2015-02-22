import Ember from 'ember';

export default Ember.ObjectController.extend({
  hasRequests: function() {
    return this.get("app.requests.today") && this.get("app.requests.yesterday");
  }.property()
});
