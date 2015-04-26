import Ember from 'ember';

export default Ember.Controller.extend({
  needs: "metrics/show",
  metric: Ember.computed.alias("controllers.metrics/show.model"),

  reset: function() {
    this.set("collapsed", true);
    this.set("newCheck", Ember.Object.create({isNew: true, cmp: "more", value: 0}));
  }.on("init"),

  isChecksSupported: function() {
    return this.get("metric.kind") === "amount";
  }.property("metric.kind"),

  actions: {
    toggle: function() {
      this.set("collapsed", !this.get("collapsed"));
    },

    save: function() {
      this.reset();
    },

    destroy: function(check) {
      if (confirm("Are you sure?")) {
        check.deleteRecord();
        check.save();
      }
    },
  }
});
