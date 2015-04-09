import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel: function() {
    var app = this.modelFor("apps/show");
    if (!app.get("isInitiated")) {
      this.transitionTo("apps.show.install", app);
    }
  }
});
