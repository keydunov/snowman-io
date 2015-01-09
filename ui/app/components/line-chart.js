import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement: function(){
    this.draw();
  },

  draw: function() {
    MG.data_graphic({
      title: this.get("title"),
      data: this.get("data"),
      width: 600,
      height: 250,
      target: '#' + this.get('elementId'),
      x_accessor: 'at',
      y_accessor: 'value'
    });
  },

  data: function() {
    var out = [];
    var yy = this.get("y").split(",");
    var points = this.get("points");
    yy.forEach(function(y) {
      out.push(points.map(function(point) {
        return {at: point.get("at"), value: point.get(y)};
      }));
    });
    return out;
  }.property("points", "y")
});
