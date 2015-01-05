import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    save: function() {
      var me = this;
      this.set("isSaving", true);
      this.set("xhr", Ember.$.post(this.buildUrl(), JSON.stringify(this.getData()), function(data) {
        me.set("isSaving", false);
        me.set("xhr", null);
        if (data.status === "ok") {
          me.transitionToRoute("collectors/index");
        } else {
          me.setErrors(data.errors);
        }
      }, "json"));
    }
  },

  deactivate: function() {
    if (this.get("xhr")) {
      this.get("xhr").abort();
    }
  },

  buildUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("collector");
  },

  getData: function() {
    return {
      collector: this.model.getProperties("kind", "hgMetric")
    };
  },

  setErrors: function(errors) {
    var model = this.model;
    model.set("errorsMessages", Ember.A());
    model.set("errorHgMetric", false);

    Ember.keys(errors).forEach(function(key) {
      if (key === "hgMetric") {
        model.set("errorHgMetric", true);
        model.get("errorsMessages").pushObjects(errors[key]);
      }
    });
  }
});
