import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function() {
      if (confirm("Are you sure?")) {
        var me = this;
        this.model.deleteRecord();
        this.model.save().then(function() {
          me.transitionToRoute("apps");
        });
      }
    }
  }
});
