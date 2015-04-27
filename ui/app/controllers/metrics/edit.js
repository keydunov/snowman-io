import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["apps/show"],
  app: Ember.computed.alias("controllers.apps/show.model"),
});
