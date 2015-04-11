import Ember from 'ember';
import layout from '../templates/components/graphite-graph';

export default Ember.Component.extend({
  layout: layout,
  tagName: "img",
  attributeBindings: ["src"],
  kind: "default",

  defaultGraphiteOptions: {
    lineMode: "connected",
    bgcolor: "white",
    fgcolor: "black",
    hideLegend: true,
    lineWidth: 1.5,
    width: 200,
    height: 200
  },

  customGraphiteOptions: function() {
    var metric = this.get("hgMetric.metricName");

    if (this.get("hgMetric.kind") == "counter" && this.get("duration") == "24h") {
      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        width: 800,
        targets: [
          "secondYAxis(color(timeShift(integral("+metric+"),'168h'),'magenta'))",
          "secondYAxis(color(timeShift(integral("+metric+"),'144h'),'gray'   ))",
          "secondYAxis(color(timeShift(integral("+metric+"),'120h'),'yellow' ))",
          "secondYAxis(color(timeShift(integral("+metric+"),'96h' ),'orange' ))",
          "secondYAxis(color(timeShift(integral("+metric+"),'72h' ),'purple' ))",
          "secondYAxis(color(timeShift(integral("+metric+"),'48h' ),'brown'  ))",
          "secondYAxis(color(timeShift(integral("+metric+"),'24h' ),'aqua'   ))",

          "color(lineWidth(transformNull("+metric+",0),1.5),'0000ff33')",
          "secondYAxis(color(lineWidth(integral("+metric+"),4),'green'))",
        ]
      });

    } else if (this.get("hgMetric.kind") == "counter" && this.get("duration") == "1h") {
      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        from: '-1h',
        width: 300,
        targets: [
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'11h'),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'10h'),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'9h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'8h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'7h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'6h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'5h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'4h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'3h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'2h' ),2),'d0d0d0'))",
          "secondYAxis(color(lineWidth(timeShift(integral("+metric+"),'1h' ),2),'d0d0d0'))",

          "color(lineWidth(transformNull("+metric+",0),1.5),'0000ff33')",
          "secondYAxis(color(lineWidth(integral("+metric+"),4),'green'))",
        ]
      });

    } else {
      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        target: metric
      });
    }
  }.property("hgMetric.kind", "hgMetric.metricName", "duration"),

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
