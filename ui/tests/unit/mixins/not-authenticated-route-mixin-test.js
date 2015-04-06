import Ember from 'ember';
import NotAuthenticatedRouteMixinMixin from 'ui/mixins/not-authenticated-route-mixin';

module('NotAuthenticatedRouteMixinMixin');

// Replace this with your real tests.
test('it works', function() {
  var NotAuthenticatedRouteMixinObject = Ember.Object.extend(NotAuthenticatedRouteMixinMixin);
  var subject = NotAuthenticatedRouteMixinObject.create();
  ok(subject);
});
