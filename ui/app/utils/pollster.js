// http://yoranbrondsema.com/live-polling-system-ember-js/
export default Ember.Object.extend({
   interval: function() {
    return 3000;
  }.property(),

  schedule: function(context, f) {
    return Ember.run.later(this, function() {
      // TODO: add to f callback support
      f.apply(context);
      this.set('timer', this.schedule(context, f));
    }, this.get('interval'));
  },

  stop: function() {
    Ember.run.cancel(this.get('timer'));
  },

  start: function(context) {
    this.set('timer', this.schedule(context, this.get('onPoll')));
  },

  onPoll: function(){
    throw "implement this";
  }
});
