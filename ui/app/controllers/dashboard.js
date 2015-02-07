import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    destroy: function(app) {
      var me = this;
      if (confirm("Are you sure?")) {
        app.deleteRecord();
        app.save();
      }
    }
  }
});
