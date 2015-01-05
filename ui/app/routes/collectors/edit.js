import Ember from 'ember';

export default Ember.Route.extend({
  deactivate: function() {
    if (this.controller.get("model.isDirty")) {
      this.controller.get("model").rollback();
    }
    this.controller.clear();
  },

  model: function (params) {
    return this.store.find('collector', params.id);
  }
});
