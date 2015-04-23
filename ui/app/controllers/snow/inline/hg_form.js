import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),

  reset: function() {
    this.set("saving", false);
    this.set("show", false);
    this.set("isHgDisabled", this.get("hgStatus") === "disabled");
    this.set("hgFormKey", this.get("hgKey"));
  },

  isHgFormValid: function() {
    return this.get("isHgDisabled") || Ember.isPresent(this.get("hgFormKey"));
  }.property("isHgDisabled", "hgFormKey"),

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
      this.set("isHgDisabled", false);
    },

    selectDisabled: function() {
      this.set("isHgDisabled", true);
    },

    cancel: function() {
      this.reset();
    },

    save: function() {
      var that = this;
      var hgStatus = that.get('isHgDisabled') ? "disabled" : "enabled";
      var hgKey = hgStatus === "enabled" ? that.get("hgFormKey") : "";
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
