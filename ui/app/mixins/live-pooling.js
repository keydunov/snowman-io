import Ember from 'ember';
import Pollster from '../utils/pollster';

export default Ember.Mixin.create({
  actions: {
    didTransition: function() {
      this.set('pollster', Pollster.create({
        onPoll: this.onPoll
      }));
      this.get('pollster').start(this);
    },
    willTransition: function() {
      this.get('pollster').stop();
      this.set('pollster', null);
    }
  }
});
