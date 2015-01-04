import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    create: function() {
      var me = this;
      this.model.save().then(function() {
        me.transitionToRoute("collectors/show", me.model);
      }, function() {});
    }
  }
});
