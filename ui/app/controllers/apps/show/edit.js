import Ember from 'ember';

export default Ember.Controller.extend({
  isFormValid: function() {
    return Ember.isPresent(this.get("appName"));
  }.property("appName"),
  isFormInvalid: Ember.computed.not("isFormValid"),

  actions: {
    save: function() {
      var me = this;
      var model = this.model;
      model.set("name", this.get("appName"));
      model.save().then(function() {
        me.transitionToRoute("apps.show.info", model);
      });
    },

    destroy: function() {
      if (confirm("Are you sure?")) {
        var me = this;
        this.model.deleteRecord();
        this.model.save().then(function() {
          me.transitionToRoute("apps");
        });
      }
    }
  }
});
