import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement: function(){
    this.draw();
  },
 
  draw: function() {
    var w1 = 31;
    var w2 = 37;
    var w3 = 32;
    var d = 4;
    var w = w1 + d + w2 + d + w3;
    var h = 20;
    var svg = d3.select("#" + this.get('elementId'))
      .append("svg")
      .attr("width", w + 6)
      .attr("height", h + 6);
    var me = this;
  
    this._calcMaxValue();
    this.set("lineFunction", d3.svg.line()
      .x(function(d, i) { return i; })
      .y(function(d) { return h - 1 - d/me.get("maxValue")*h; })
      .interpolate("linear"));

    this.set("gCurrent", svg.append("g").attr("transform", "translate(" + (3 + w3 + d + w2 + d) + ",3)"));
    this.set("gDay", svg.append("g").attr("transform", "translate(" + (3 + w3 + d) + ",3)"));
    this.set("gMonth", svg.append("g").attr("transform", "translate(3,3)"));

    this.get("gCurrent").append("path")
      .attr("d", this.get("lineFunction")(this.get("trend.current")))
      .attr("stroke", "blue")
      .attr("stroke-width", 1.5)
      .attr("fill", "none");

    this.get("gDay").append("path")
      .attr("d", this.get("lineFunction")(this.get("trend.day")))
      .attr("stroke", "blue")
      .attr("stroke-width", 1.5)
      .attr("fill", "none");

    this.get("gMonth").append("path")
      .attr("d", this.get("lineFunction")(this.get("trend.month")))
      .attr("stroke", "blue")
      .attr("stroke-width", 1.5)
      .attr("fill", "none");
  },

  trendUpdated: function() {
    this._calcMaxValue();

    this.get("gCurrent").select("path")
      .attr("d", this.get("lineFunction")(this.get("trend.current")));

    this.get("gDay").select("path")
      .attr("d", this.get("lineFunction")(this.get("trend.day")));

    this.get("gMonth").select("path")
      .attr("d", this.get("lineFunction")(this.get("trend.month")));
  }.observes("trend.generated_at"),

  _calcMaxValue: function() {
    var max_value = 0;
    this.get("trend.current").forEach(function(d) { if (d > max_value) { max_value = d; } });
    this.get("trend.day").forEach(function(d) { if (d > max_value) { max_value = d; } });
    this.get("trend.month").forEach(function(d) { if (d > max_value) { max_value = d; } });
    if (max_value === 0) { max_value = 1; }
    this.set("maxValue", max_value);
  }
});
