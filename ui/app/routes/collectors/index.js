
import Ember from 'ember';

export default Ember.Route.extend({
  model: function () {
    // TODO: This is realy right way to prevent such error?
    // Attempted to handle event `pushedData` while in state root.loaded.updated.invalid
    if (this.controllerFor("collectors/edit").get("model.isDirty")) {
      this.controllerFor("collectors/edit").get("model").rollback();
    }
    return this.store.find('collector');
  }
});
