import Ember from 'ember';

export default Ember.Controller.extend({
  collapsed: true,
  cmp: "more",
  value: 0,

  isSupported: function() {
    return this.get("model.kind") == "amount";
  }.property("model.kind"),

  actions: {
    add: function() {
      this.set("collapsed", false);
    },

    cancel: function() {
      this.set("collapsed", true);
    },

    clickMore: function() {
      this.set("cmp", "more");
    },

    clickLess: function() {
      this.set("cmp", "less");
    },

    save: function() {
      var me = this;
      var check = this.store.createRecord("check");
      this.get("model.checks").pushObject(check);
      check.set("cmp", this.get("cmp"));
      check.set("value", this.get("value"));
      check.save().then(function() {
        me.set("collapsed", true);
      });
    },
  }
});
