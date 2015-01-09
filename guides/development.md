# SnowmanIO Development Guide

UI is Ember.js application backed with Sinatra. The UI was developed with help of
[ember-cli](http://www.ember-cli.com/). The application sources are located at `ui` folder.

## Prepare

``` bash
cd ui && npm install && bower install
```

## Run

``` bash
rake dev:run
```

See your development version of Ember application on `http://localhost:4200` by default and
snowman at `http://localhost:4567`.

## Rake tasks

* `rake dev:random` - fill 1 month of test metric
* `rake dev:collect` - force gather metrics
* `rake dev:aggregate` - aggregate metric for yesterday
* `rake dev:report` - generate report for yesterday
