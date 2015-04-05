import Ember from 'ember';

export default Ember.Mixin.create({
  beforeModel: function(transition) {
    this._super(transition);
    if (this.get("session.isAuthenticated")) {
      this.transitionTo("snow.dashboard");
    }
  }
});
