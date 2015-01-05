import Ember from 'ember';

export default Ember.Route.extend({
  model: function (params) {
    var store = this.store;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      store.find('collector', params.id).then(function(model) {
        resolve(Ember.Object.create({
          id: model.get("id"),
          kind: model.get("kind"),
          hgMetric: model.get("hgMetric"),

          errorsMessages: Ember.A(),
          errorHgMetric: false
        }));
      }, function() {
        reject.apply(this, arguments);
      });
    });
  },

  deactivate: function() {
    this.controller.deactivate();
  }
});
