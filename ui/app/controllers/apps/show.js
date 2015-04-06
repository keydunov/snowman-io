import Ember from 'ember';

export default Ember.ObjectController.extend({
  needs: ["snow"],
  baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),

  isHgEnabled: Ember.computed.equal("hgStatus", "enabled"),

  hgKinds: ["time", "counter", "amount", "deploy"],

  hgNameEmpty: Ember.computed.empty("hgName"),
  hgMetricNameEmpty: Ember.computed.empty("hgMetricName"),
  hgFormValid: function() {
    return !this.get("hgNameEmpty") && !this.get("hgMetricNameEmpty");
  }.property("hgNameEmpty", "hgMetricNameEmpty"),

  hasRequests: function() {
    return this.get("requests.today") && this.get("requests.yesterday");
  }.property("requests.today", "requests.yesterday")
});
