import DS from 'ember-data';
import config from '../config/environment';

export default DS.RESTAdapter.extend({
  host: config.environment == 'development' ? 'http://localhost:4567' : null,
  namespace: 'api'
});
