import Ember from 'ember';

export default Ember.Controller.extend({
  needs: "metrics/show",
  metric: Ember.computed.alias("controllers.metrics/show.model"),

  reset: function() {
    this.set("collapsed", true);
    this.set("newCheck", Ember.Object.create({
      isNew: true,
      metric: this.get("metric"),
      cmp: "more",
      value: 0
    }));
  }.on("init"),

  isChecksSupported: function() {
    return this.get("metric.kind") === "amount";
  }.property("metric.kind"),

  actions: {
    toggle: function() {
      this.set("collapsed", !this.get("collapsed"));
    },

    cancel: function() {
      this.reset();
    },

    save: function() {
      var me = this;
      var metric = this.get("metric");

      var check = this.store.createRecord("check", {
        cmp: this.get("newCheck.cmp"),
        value: this.get("newCheck.value"),
      });
      metric.get("checks").pushObject(check);
      check.save().then(function() {
        me.reset();
      });
    },

    destroy: function(check) {
      if (confirm("Are you sure?")) {
        check.deleteRecord();
        check.save();
      }
    },
  }
});
