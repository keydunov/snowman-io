import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    save: function() {
      var me    = this;
      var model = this.model;

      model.save().then(function() {
        me.transitionToRoute("apps.show", model);
      });
    }
  }
});
