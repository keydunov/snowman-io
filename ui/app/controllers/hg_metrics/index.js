import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),

  actions: {
    destroy: function(hgMetric) {
      if (confirm("Are you sure?")) {
        hgMetric.deleteRecord();
        hgMetric.save();
      }
    }
  }
});
