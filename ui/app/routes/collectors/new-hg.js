import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord('collector', {kind: "HG", hgMetric: ""});
  },

  deactivate: function() {
    if (this.controller.get("model.isNew")) {
      this.controller.get("model").rollback();
    }
  }
});
