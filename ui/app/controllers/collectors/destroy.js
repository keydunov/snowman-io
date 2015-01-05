import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function() {
      var me = this;
      var model = this.model;

      this.store.deleteRecord(model);
      model.save().then(function() {
        me.transitionToRoute("collectors/index");
      });
    }
  }
});
