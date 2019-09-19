Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
config.webpacker.check_yarn_integrity = true

  config.time_zone = 'Eastern Time (US & Canada)'
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # config.action_controller.action_on_unpermitted_parameters = :ignore

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { :host => ENV['DEFAULT_URL'] }
  
  config.action_mailer.smtp_settings = {
    :address => ENV['smtp_address'],
    :port => ENV['smtp_port'],
    :domain => ENV['smtp_domain'],
    :user_name            => ENV['smtp_user_name'],
    :password             => ENV['smtp_password'],
    :authentication => :ENV['smtp_authentication'],
    :enable_starttls_auto => ENV['smtp_enable_starttls_auto']
  }
  config.active_job.queue_adapter = :sidekiq

  config.paperclip_defaults = {
    storage: :s3,
    s3_protocol: :https,
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    url: ':s3_domain_url',
    path: '/:class/:assetable_type/:id_partition/:style/:filename'
  }

  config.textris_delivery_method = :twilio


  config.after_initialize do
    Bullet.enable = true
    # Bullet.sentry = true
    # Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    # Bullet.growl = true
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    Bullet.rails_logger = true
    # Bullet.honeybadger = true
    # Bullet.bugsnag = true
    # Bullet.airbrake = true
    # Bullet.rollbar = true
    # Bullet.add_footer = true
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
    # Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware' ]
    # Bullet.slack = { webhook_url: 'http://some.slack.url', channel: '#default', username: 'notifier' }
  end

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true  
  
end
