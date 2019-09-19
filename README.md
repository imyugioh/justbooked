# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### React on Rails ###
* Webpacker
For development, run `bin/webpack-dev-server` command in a terminal separate from `bundle exec rails s` so that the changes made inside react components are updated real time.
However for production, we will use precompiled react code so we don't need to run webpack-dev-server for production mode.
And Webpacker hooks up a new webpacker:compile task to assets:precompile, which gets run whenever you run assets:precompile.
So after running assets precompile, all react components will be working on production mode.

* React_Rails
All react components should be inside app/javascript/components. And you can just use `react_component` helper to render react component and that's all - <%= react_component "CartsApp" %>.
https://github.com/reactjs/react-rails

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact
