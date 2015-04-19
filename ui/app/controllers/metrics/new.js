import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["apps/show"],
  app: Ember.computed.alias("controllers.apps/show.model"),

  actions: {
    submit: function() {
      var me = this;
      var app = this.get("app");
      var metric = this.get("model");
      app.get("metrics").pushObject(metric);
      me.set("saving", true);
      metric.save().then(function() {
        me.set("saving", false);
        me.transitionToRoute("metrics.show", app, metric);
      });
    }
  }
});
