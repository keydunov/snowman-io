import Ember from 'ember';

export default Ember.Controller.extend({
  resetForm: function() {
    this.set("collapsed", true);
    this.set("cmp", "more");
    this.set("value", 0);
  }.on("init"),

  isSupported: function() {
    return this.get("model.kind") === "amount";
  }.property("model.kind"),

  actions: {
    add: function() {
      this.set("collapsed", false);
    },

    cancel: function() {
      this.resetForm();
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
        me.resetForm();
      });
    },
  }
});
