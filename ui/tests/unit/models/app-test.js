import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('app', {
  // Specify the other units that are required for this test.
  needs: ['model:hg-metric']
});

test('it exists', function(assert) {
  var model = this.subject();
  // var store = this.store();
  assert.ok(!!model);
});
