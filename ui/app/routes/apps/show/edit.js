import Ember from 'ember';

export default Ember.Route.extend({
  setupController: function(controller, model) {
    // var app = this.modelFor("apps.show");
    this._super(controller, model);
    controller.set("appName", model.get("name"));
  }
});
