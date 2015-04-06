import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  reportRecipients: Ember.computed.alias("controllers.snow.model.report_recipients"),
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),

  hgFormShow: false,
  hgSaving: false,

  hgStatusDisabled: Ember.computed.equal("hgStatus", "disabled"),
  isHgDisabled: Ember.computed.oneWay('hgStatusDisabled'),
  isHgEnabled: Ember.computed.not('isHgDisabled'),

  isHgKeyEmpty: Ember.computed.empty("hgKey"),
  isHgSaveBtnDisabled: Ember.computed.and("isHgEnabled", "isHgKeyEmpty"),

  hgStatusText: function() {
    if (this.get("hgSaving")) {
      return "saving...";
    } else {
      return this.get("hgStatus");
    }
  }.property("hgStatus", "hgSaving"),

  actions: {
    hgChange: function() {
      this.set("hgFormShow", !this.get("hgFormShow"));
    },

    hgSelectEnabled: function() {
      this.set("isHgDisabled", false);
    },

    hgSelectDisabled: function() {
      this.set("isHgDisabled", true);
    },

    hgCancel: function() {
      this.set("hgFormShow", false);
    },

    hgSave: function() {
      var that = this;
      var hgStatus = that.get('isHgDisabled') ? "disabled" : "enabled";
      var hgKey = that.get("hgKey");
      that.set("hgFormShow", false);
      that.set("hgSaving", true);
      Ember.$.post(that._baseUrl() + "/hg", {hg_status: hgStatus, hg_key: hgKey}, function(data) {
        that.set("hgStatus", data.hg_status);
        that.set("hgKey", data.hg_key);
        that.set("hgSaving", false);
      });
    }
  },

  _baseUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("");
  }
});
