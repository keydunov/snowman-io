import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function(metric) {
      if (confirm("Are you sure?")) {
        metric.deleteRecord();
        metric.save();
      }
    }
  }
});
