Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV['REDISLAB_URL'],
    password: ENV['REDISLAB_PASS']
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDISLAB_URL'],
    password: ENV['REDISLAB_PASS']
  }
end
