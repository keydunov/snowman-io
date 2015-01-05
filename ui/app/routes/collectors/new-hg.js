import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return Ember.Object.create({
      kind: "HG",
      hgMetric: "",

      errorsMessages: Ember.A(),
      errorHgMetric: false
    });
  },

  deactivate: function() {
    this.controller.deactivate();
  }
});
