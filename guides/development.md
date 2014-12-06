# SnowmanIO Development Guide

## UI

UI is Ember.js application backed with Sinatra as backend. The UI is developing using
[ember-cli](http://www.ember-cli.com/). Sources are located at `ui` folder. To run
development version of applcation fire in console:

``` bash
cd ui
npm install && bower install
ember server
```

It executes application on `http://localhost:4200` by default. In next console execute
`bundle exec snowman` to start SnowmanIO backend. You are ready to hack UI.

__NOTE:__ if you update sources in UI folder dont forget compile app:

``` bash
cd ui
./release_new_ui
```

## Document Changelog

2014.12.17
- First Draft
