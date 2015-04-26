import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function(check) {
      if (confirm("Are you sure?")) {
        check.deleteRecord();
        check.save();
      }
    },
  }
});
