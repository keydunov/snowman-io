import DS from 'ember-data';

var Check = DS.Model.extend({
  name: DS.attr('string')
});

Check.reopenClass({
  FIXTURES: [
    {
      id: 1,
      name: "First Check",
    },
    {
      id: 2,
      name: "Second Check"
    }
  ]
});

export default Check;
