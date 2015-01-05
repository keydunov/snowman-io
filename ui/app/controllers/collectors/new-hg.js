import Ember from 'ember';

export default Ember.ObjectController.extend({
  actions: {
    save: function() {
      var me = this;
      this.set("inProgress", true);
      this.set("xhr", Ember.$.ajax({
        url: this.buildUrl(),
        type: "POST",
        data: JSON.stringify(this.getData()),
        dataType: "json",
        success: function(data) {
          me.set("inProgress", false);
          me.set("xhr", null);
          if (data.status === "ok") {
            me.transitionToRoute("collectors/show", data.collector.id);
          } else {
            me.setErrors(data.errors);
          }
        }
      }));
    }
  },

  deactivate: function() {
    if (this.get("xhr")) {
      this.get("xhr").abort();
      this.set("inProgress", false);
      this.set("xhr", null);
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
