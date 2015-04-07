import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function(app) {
      if (confirm("Are you sure?")) {
        app.deleteRecord();
        app.save();
      }
    }
  }
});
