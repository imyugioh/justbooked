source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
# Use CoffeeScript for .coffee assets and views
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rake', '< 11.0'

# Tiny, fast & funny HTTP server
# gem 'thin'
gem 'thin'
gem 'figaro'
gem 'font-awesome-rails'
gem 'chosen-rails'
gem 'devise'
gem 'geokit'
gem 'geokit-rails', github: 'geokit/geokit-rails'
gem 'city-state'
gem 'active_model_serializers'
gem 'pg_search'
gem 'will_paginate', '~> 3.0.6'
gem 'paperclip', '~> 4.3'
gem 'aws-sdk-v1'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'friendly_id'
gem 'activeadmin', '~> 1.0.0.pre1'
gem 'active_admin_theme'
gem 'activeadmin_reorderable'
gem 'country_select'
gem 'acts_as_votable', '~> 0.10.0'
gem 'money-rails'
gem 'roadie-rails'
gem 'acts_as_commentable'
gem 'fanout' # realtime events
gem 'has_secure_token'
# gem 'slim-rails'
gem 'ratyrate'
gem 'switch_user'
gem 'draper', '= 2.1.0'
gem 'gon'
gem 'countries'
gem 'acts_as_list'
gem 'validate_url'
gem 'awesome_print'
gem 'invisible_captcha'

gem 'activeadmin_hstore_editor'
gem 'active_admin_datetimepicker'

# perform actions async with sidekiq and redis
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'redis'
gem 'newrelic_rpm'
gem 'le'

gem 'mixpanel-ruby'
gem 'sendgrid'
gem 'whenever', require: false
gem 'ruby-progressbar'
gem 'impressionist'
gem 'highcharts-rails', '~> 3.0.0'
gem 'config'
gem 'stripe'
gem 'graphql', '~> 1.6.8'
gem 'wicked'

gem 'dotenv-rails', :require => 'dotenv/rails-now'
gem 'dropzonejs-rails'
gem "omnicontacts"
gem 'rack-cors'
gem 'twilio-ruby'
gem 'textris'
gem 'nested_form'

# webpack for react
gem 'webpacker', '~> 3.5'
gem 'react-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Quiet Assets turns off the Rails asset pipeline log.
  gem 'quiet_assets'

  # It allows you to create seed data files from the existing
  # data in your database.
  gem 'seed_dump'

  # deployment
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq'
end

group :Assets do
  gem 'sass-rails', '~> 4.0.3'
  gem 'uglifier', '>= 1.3.0'
end

# simple, fast, threaded, and highly concurrent
# HTTP 1.1 server for Ruby/Rack applications
gem 'puma'
gem 'execjs'
gem 'therubyracer'

group :development, :test do
  gem 'faker'
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-rails'
  gem 'bullet'
  gem 'letter_opener'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'factory_girl_rails', '~> 4.0', require: false
  gem 'shoulda-matchers'
  gem 'rubocop', '~> 0.36.0', require: false
  gem 'simplecov', require: false, group: :test
end

group :test do
  gem 'database_cleaner'
  gem 'stripe-ruby-mock', '~> 2.4.0', require: 'stripe_mock'
  gem 'rspec-sidekiq'
end

# heroku specific gem
# gem 'rails_12factor'
