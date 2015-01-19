import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement: function(){
    this.draw();
  },
 
  draw: function() {
    var w = 288;
    var h = 20;
    var svg = d3.select("#" + this.get('elementId'))
      .append("svg")
      .attr("width", w + 8)
      .attr("height", h + 8);
    var g = svg.append("g").attr("transform", "translate(4,4)");
    var max_value = 0;
    this.get("data").forEach(function(p) {
      if (p.value > max_value) {
        max_value = p.value;
      }
    });
    if (max_value === 0) {
      max_value = 1;
    }
    var lineFunction = d3.svg.line()
      .x(function(d) { return d.at/288*w; })
      .y(function(d) { return h - 1 - d.value/max_value*h; })
      .interpolate("linear");
    g.append("path")
      .attr("d", lineFunction(this.get("data")))
      .attr("stroke", "blue")
      .attr("stroke-width", 1.5)
      .attr("fill", "none");
  }
});
