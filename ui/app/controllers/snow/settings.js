import Ember from 'ember';

export default Ember.Controller.extend({
  needs: ["snow"],
  baseUrl: Ember.computed.alias("controllers.snow.model.base_url"),
  reportRecipients: Ember.computed.alias("controllers.snow.model.report_recipients"),
});
