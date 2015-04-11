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
    var deployMetric = this.get("hgDeployMetric.metricName");
    var kind = this.get("hgMetric.kind");
    var second = null;
    if (kind === "time") {
      second = metric;
      metric += ":90pct";
    }
    var targets = [];

    if ((kind === "time" || kind === "amount") && this.get("duration") === "24h") {
      targets = targets.concat([
        "color(timeShift("+metric+",'168h'),'FF009740')",
        "color(timeShift("+metric+",'144h'),'A200FF40')",
        "color(timeShift("+metric+",'120h'),'00ABA940')",
        "color(timeShift("+metric+",'96h' ),'8CBF2640')",
        "color(timeShift("+metric+",'72h' ),'A0500040')",
        "color(timeShift("+metric+",'48h' ),'E671B840')",
        "color(timeShift("+metric+",'24h' ),'F0960940')",
      ]);

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      if (second) {
        targets.push("color(lineWidth("+second+",2),'blue')");
      }

      targets = targets.concat([
        "color(lineWidth("+metric+",2),'green')",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        width: 800,
        targets: targets
      });


    } else if ((kind === "time" || kind === "amount") && this.get("duration") === "1h") {
      targets = targets.concat([
        "color(lineWidth(timeShift("+metric+",'11h'),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'10h'),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'9h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'8h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'7h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'6h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'5h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'4h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'3h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'2h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+metric+",'1h' ),2),'d0d0d0')",
      ]);

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      if (second) {
        targets.push("color(lineWidth("+second+",2),'blue')");
      }

      targets = targets.concat([
        "color(lineWidth("+metric+",2),'green')",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        from: '-1h',
        width: 300,
        targets: targets
      });


    } else if (kind === "counter" && this.get("duration") === "24h") {
      targets = targets.concat([
        "secondYAxis(color(timeShift(integral("+metric+"),'168h'),'magenta'))",
        "secondYAxis(color(timeShift(integral("+metric+"),'144h'),'gray'   ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'120h'),'yellow' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'96h' ),'orange' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'72h' ),'purple' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'48h' ),'brown'  ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'24h' ),'aqua'   ))",
      ]);

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      targets = targets.concat([
        "color(lineWidth(transformNull("+metric+",0),1.5),'0000ff33')",
        "secondYAxis(color(lineWidth(integral("+metric+"),4),'green'))",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        width: 800,
        targets: targets
      });


    } else if (kind === "counter" && this.get("duration") === "1h") {
      targets = targets.concat([
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
      ]);

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      targets = targets.concat([
        "color(lineWidth(transformNull("+metric+",0),1.5),'0000ff33')",
        "secondYAxis(color(lineWidth(integral("+metric+"),4),'green'))",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        from: '-1h',
        width: 300,
        targets: targets
      });


    } else {
      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        target: metric
      });
    }
  }.property("hgMetric.kind", "hgMetric.metricName", "duration", "hgDeployMetric.metricName"),

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
