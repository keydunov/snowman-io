export function initialize(container, application) {
  application.inject('route', 'storage', 'service:storage');
}

export default {
  name: 'storage-service',
  initialize: initialize
};
