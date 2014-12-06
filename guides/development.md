# SnowmanIO Development Guide

UI is Ember.js application backed with Sinatra. The UI was developed with help of
[ember-cli](http://www.ember-cli.com/). The application sources are located at `ui` folder.

## Prepare

``` bash
cd ui
npm install && bower install
```

## Run

Fire ember-cli server:

``` bash
cd ui
ember s
```

See your development version of application on `http://localhost:4200` by default.

Execute snowman backend.

``` bash
rerun -d lib bundle exec snowman
```

__NOTE:__ if you update sources in UI folder dont forget compile app:

``` bash
cd ui
./release_new_ui
```

## Document Changelog

2014.12.17
- First Draft
