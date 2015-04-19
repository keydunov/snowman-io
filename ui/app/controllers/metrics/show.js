import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow", "apps/show"],
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key"),
  app: Ember.computed.alias("controllers.apps/show.model"),
});
