import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function(hgMetric) {
      if (confirm("Are you sure?")) {
        hgMetric.deleteRecord();
        hgMetric.save();
      }
    }
  }
});
