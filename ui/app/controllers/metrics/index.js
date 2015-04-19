import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  isHgEnabled: Ember.computed.equal("hgStatus", "enabled"),

  isMetricAllowToAdd: function() {
    return this.get("isHgEnabled");
  }.property("isHgEnabled"),

  actions: {
    destroy: function(metric) {
      if (confirm("Are you sure?")) {
        metric.deleteRecord();
        metric.save();
      }
    }
  }
});
