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

    if ((kind == "time" || kind == "amount") && this.get("duration") == "24h") {
      var base = null;
      var second = null;
      if (kind == "time") {
        base = metric + ":90pct";
        second = metric;
      } else  {
        base = metric;
      }

      var targets = [
        "color(timeShift("+base+",'168h'),'FF009740')",
        "color(timeShift("+base+",'144h'),'A200FF40')",
        "color(timeShift("+base+",'120h'),'00ABA940')",
        "color(timeShift("+base+",'96h' ),'8CBF2640')",
        "color(timeShift("+base+",'72h' ),'A0500040')",
        "color(timeShift("+base+",'48h' ),'E671B840')",
        "color(timeShift("+base+",'24h' ),'F0960940')",
      ];

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      if (second) {
        targets.push("color(lineWidth("+second+",2),'blue')");
      }

      targets = targets.concat([
        "color(lineWidth("+base+",2),'green')",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        width: 800,
        targets: targets
      });


    } else if ((kind == "time" || kind == "amount") && this.get("duration") == "1h") {
      var base = null;
      var second = null;
      if (kind == "time") {
        base = metric + ":90pct";
        second = metric;
      } else  {
        base = metric;
      }

      var targets = [
        "color(lineWidth(timeShift("+base+",'11h'),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'10h'),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'9h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'8h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'7h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'6h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'5h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'4h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'3h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'2h' ),2),'d0d0d0')",
        "color(lineWidth(timeShift("+base+",'1h' ),2),'d0d0d0')",
      ];

      if (deployMetric) {
        targets.push("drawAsInfinite(color("+deployMetric+",'ff000077'))");
      }

      if (second) {
        targets.push("color(lineWidth("+second+",2),'blue')");
      }

      targets = targets.concat([
        "color(lineWidth("+base+",2),'green')",
      ]);

      return Ember.$.extend({}, this.get("defaultGraphiteOptions"), {
        from: '-1h',
        width: 300,
        targets: targets
      });


    } else if (kind == "counter" && this.get("duration") == "24h") {
      var targets = [
        "secondYAxis(color(timeShift(integral("+metric+"),'168h'),'magenta'))",
        "secondYAxis(color(timeShift(integral("+metric+"),'144h'),'gray'   ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'120h'),'yellow' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'96h' ),'orange' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'72h' ),'purple' ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'48h' ),'brown'  ))",
        "secondYAxis(color(timeShift(integral("+metric+"),'24h' ),'aqua'   ))",
      ];

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


    } else if (kind == "counter" && this.get("duration") == "1h") {
      var targets = [
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
      ];

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
