import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    destroy: function() {
      var me = this;
      this.set("inProgress", true);
      this.set("xhr", Ember.$.ajax({
        url: this.buildUrl(),
        type: "DELETE",
        data: JSON.stringify({}),
        dataType: "json",
        success: function(data) {
          me.set("inProgress", false);
          me.set("xhr", null);
          me.transitionToRoute("collectors/index");
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
    return adapter.buildURL("collector", this.model.id);
  }
});
