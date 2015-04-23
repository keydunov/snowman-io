import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),

  reset: function() {
    this.set("saving", false);
    this.set("show", false);
    this.set("disabled", this.get("hgStatus") === "disabled");
    this.set("formKey", this.get("hgKey"));
  },

  formValid: function() {
    return this.get("disabled") || Ember.isPresent(this.get("formKey"));
  }.property("disabled", "formKey"),

  statusText: function() {
    if (this.get("saving")) {
      return "saving...";
    } else {
      return this.get("hgStatus");
    }
  }.property("hgStatus", "saving"),

  actions: {
    change: function() {
      this.set("show", !this.get("show"));
    },

    selectEnabled: function() {
      this.set("disabled", false);
    },

    selectDisabled: function() {
      this.set("disabled", true);
    },

    cancel: function() {
      this.reset();
    },

    save: function() {
      var that = this;
      var hgStatus = that.get('disabled') ? "disabled" : "enabled";
      var hgKey = hgStatus === "enabled" ? that.get("formKey") : "";
      that.set("show", false);
      that.set("saving", true);
      Ember.$.post(that._baseUrl() + "/hg", {hg_status: hgStatus, hg_key: hgKey}, function(data) {
        that.set("hgStatus", data.hg_status);
        that.set("hgKey", data.hg_key);
        that.set("saving", false);
      });
    }
  },

  _baseUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("");
  }
});
