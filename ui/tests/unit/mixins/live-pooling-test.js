import Ember from 'ember';
import LivePoolingMixin from 'ui/mixins/live-pooling';

module('LivePoolingMixin');

// Replace this with your real tests.
test('it works', function() {
  var LivePoolingObject = Ember.Object.extend(LivePoolingMixin);
  var subject = LivePoolingObject.create();
  ok(subject);
});
