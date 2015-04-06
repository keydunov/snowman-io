import Ember from 'ember';
import AuthenticatedRouteMixin from 'simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  model: function() {
    return Ember.$.get(this._infoUrl());
  },

  setupController: function(controller, model) {
    controller.set('baseUrl', model.base_url);
    controller.set('reportRecipients', model.report_recipients);
    controller.set('hgStatus', model.hg_status);
    controller.set('hgKey', model.hg_key);
  },

  _infoUrl: function() {
    var adapter = this.container.lookup('adapter:application');
    return adapter.buildURL("") + "/info";
  }
});
