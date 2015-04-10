import Ember from 'ember';
import layout from '../templates/components/graphite-graph';

export default Ember.Component.extend({
  layout: layout,
  tagName: "img",
  attributeBindings: ["src"],
  kind: "default",
  options: {},

  defaultGraphiteOptions: {
    lineMode: "connected",
    bgcolor: "white",
    fgcolor: "black",
    hideLegend: true,
    lineWidth: 1.5,
    width: 1100,
    height: 250
  },

  customGraphiteOptions: function() {
    return Ember.$.extend({target: this.get("target")}, this.get("defaultGraphiteOptions"));
  }.property("target"),

  src: function() {
    var src = "https://www.hostedgraphite.com" + this.get("hgKey") + "/graphite/render?";

    Ember.$.each(this.get("customGraphiteOptions"), function (key, value) {
      if (key === "targets") {
          Ember.$.each(value, function (index, value) {
              src += "&target=" + value;
          });
      } else if (value !== null && key !== "url") {
          src += "&" + key + "=" + value;
      }
    });

    return src.replace(/\?&/, "?");
  }.property("customGraphiteOptions", "hgKey")
});
