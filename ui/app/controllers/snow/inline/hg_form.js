import Ember from 'ember';

export default Ember.Controller.extend({
  reset: function() {
    console.log("reset");
  },

  // needs: ["snow"],
  // baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  // reportRecipients: Ember.computed.alias("controllers.snow.model.report_recipients"),
  // hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  // hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),
  //
  // resetHgForm: function() {
  //   this.set("hgSaving", false);
  //   this.set("hgFormShow", false);
  //   this.set("isHgDisabled", this.get("hgStatus") === "disabled");
  //   this.set("hgFormKey", this.get("hgKey"));
  // },
  //
  // isHgFormValid: function() {
  //   return this.get("isHgDisabled") || Ember.isPresent(this.get("hgFormKey"));
  // }.property("isHgDisabled", "hgFormKey"),
  //
  // hgStatusText: function() {
  //   if (this.get("hgSaving")) {
  //     return "saving...";
  //   } else {
  //     return this.get("hgStatus");
  //   }
  // }.property("hgStatus", "hgSaving"),
  //
  // actions: {
  //   hgChange: function() {
  //     this.set("hgFormShow", !this.get("hgFormShow"));
  //   },
  //
  //   hgSelectEnabled: function() {
  //     this.set("isHgDisabled", false);
  //   },
  //
  //   hgSelectDisabled: function() {
  //     this.set("isHgDisabled", true);
  //   },
  //
  //   hgCancel: function() {
  //     this.resetHgForm();
  //   },
  //
  //   hgSave: function() {
  //     var that = this;
  //     var hgStatus = that.get('isHgDisabled') ? "disabled" : "enabled";
  //     var hgKey = hgStatus === "enabled" ? that.get("hgFormKey") : "";
  //     that.set("hgFormShow", false);
  //     that.set("hgSaving", true);
  //     Ember.$.post(that._baseUrl() + "/hg", {hg_status: hgStatus, hg_key: hgKey}, function(data) {
  //       that.set("hgStatus", data.hg_status);
  //       that.set("hgKey", data.hg_key);
  //       that.set("hgSaving", false);
  //     });
  //   }
  // },
  //
  // _baseUrl: function() {
  //   var adapter = this.container.lookup('adapter:application');
  //   return adapter.buildURL("");
  // }
});
