import Ember from 'ember';

export default Ember.Route.extend({
  model: function(params) {
    return this.storage.collectorFind(params.id);
  }
});
