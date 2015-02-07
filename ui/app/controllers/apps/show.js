import Ember from 'ember';
import config from '../../config/environment';

export default Ember.ObjectController.extend({
  isDevelopment: function() {
    return true;
  }.property(),

  actions: {
    destroy: function() {
      if (confirm("Are you sure?")) {
        var me = this;
        this.model.deleteRecord();
        this.model.save().then(function() {
          me.transitionToRoute("apps/index");
        });
      }
    }
  }
});
