import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Component.extend({
  loading: Ember.computed.empty("datapoints"),
  datapoints: [],
  classNames: ["col-xs-6"],
  precision: "5min",

  load: function() {
    var path = "/metrics/" +
               this.get("metric.id") +
               "/render" +
               "?precision=" +
               this.get("precision") +
               "&target=" +
               this.get("target");

    Ember.$.getJSON(ENV.api + path).then((data) => {
      this.set("datapoints", data.datapoints);
    });
  }.on("didInsertElement"),

  chartData: function() {
    return {
      labels: this.get("datapoints").map((datapoint) => { return moment(datapoint.at).format("hh:mm") }),
      datasets: [
          {
            label: "Metric name",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: this.get("datapoints").mapBy("value")
          }
      ]
    }
  }.property("datapoints")
});
