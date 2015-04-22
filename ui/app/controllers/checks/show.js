import Ember from 'ember';

export default Ember.Controller.extend({
  isEditing: false,

  actions: {
    destroy: function() {
      if (confirm("Are you sure?")) {
        this.model.deleteRecord();
        this.model.save();
      }
    },

    edit: function() {
      this.set("isEditing", true);
    }
  }
});
