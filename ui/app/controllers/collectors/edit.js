import Ember from 'ember';

export default Ember.ObjectController.extend({
  hasErrors: Ember.computed.notEmpty("modelErrors"),

  clear: function() {
    this.set("modelErrors", []);
    this.set("modelAttributesWithErrors", []);
  },

  actions: {
    save: function() {
      var me = this;
      var model = this.model;

      model.save().then(function() {
        me.transitionToRoute("collectors/show", model);
      }, function() {
        // Such hack code to make Rails like server side validations
        me.set("modelErrors", Ember.copy(model.get("errors.messages")));

        // WARNING: I use private method here :(
        var modelAttributesWithErrors = {}
        model.get("errors.errorsByAttributeName").forEach(function(value, key) {
          modelAttributesWithErrors[key] = true;
        });
        me.set("modelAttributesWithErrors", modelAttributesWithErrors);
      });
    }
  }
});
