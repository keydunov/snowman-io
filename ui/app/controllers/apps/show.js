import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow", "apps"],
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  isHgEnabled: Ember.computed.equal("hgStatus", "enabled"),
  apps: Ember.computed.alias("controllers.apps.model")
});
