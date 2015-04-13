import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  hgStatus: Ember.computed.alias("controllers.snow.model.hg_status"),
  isHgEnabled: Ember.computed.equal("hgStatus", "enabled")
});
