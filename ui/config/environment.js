/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'ui',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    ENV.APP.LOG_VIEW_LOOKUPS = true;

    ENV.baseHost = 'http://localhost:4567';
    ENV.contentSecurityPolicy = {
      'connect-src': "'self' http://localhost:4567",
      'style-src': "'self' 'unsafe-inline'"
    };
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  ENV['simple-auth-devise'] = {
    serverTokenEndpoint: '/api/users/login',
    identificationAttributeName: 'email'
  }

  ENV['simple-auth'] = {
    authorizer: 'simple-auth-authorizer:devise',
    routeAfterAuthentication: 'apps'
  }

  if (environment === 'development') {
    ENV['simple-auth']['crossOriginWhitelist'] = ['http://localhost:4567'];
  }

  return ENV;
};

