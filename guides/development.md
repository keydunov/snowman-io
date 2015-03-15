# SnowmanIO Development Guide

UI is Ember.js application backed with Sinatra. The UI was developed with help of
[ember-cli](http://www.ember-cli.com/). The application sources are located at `ui` folder.

## Prepare

``` bash
bundle
cd ui && npm install && bower install && cd ..
```

## Run for Development

``` bash
rake dev:run
```

See your development version of Ember application on `http://localhost:4200` by default and
snowman at `http://localhost:4567`.
