import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  hgKey: Ember.computed.alias("controllers.snow.model.hg_key")
});
