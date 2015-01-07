import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    return this.store.find("collector", params.id);
  },

  deactivate: function() {
    if (this.controller.get("model.isDirty")) {
      this.controller.get("model").rollback();
    }
  }
});
