import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    destroy: function() {
      var me = this;
      this.model.deleteRecord();
      this.model.save().then(function() {
        me.transitionToRoute("collectors/index");
      });
    }
  }
});
