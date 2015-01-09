import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return Ember.RSVP.hash({
      metric: this.store.find('metric', params.id),
      fiveMinPoints: this.store.find('point', {metricId: params.id, kind: "5mins"}),
      dailyPoints: this.store.find('point', {metricId: params.id, kind: "daily"})
    });
  }
});
