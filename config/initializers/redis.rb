require 'redis'

REDIS_CONFIG = YAML.load(
  File.open(
    Rails.root.join('config/redis.yml')
  )
).symbolize_keys

dflt = REDIS_CONFIG[:default].symbolize_keys


if ENV['RUN_ON_HEROKU']
  [:port, :password, :db].each { |k| dflt.delete k }
  dflt[:host] = ENV['REDIS_URL']
else
  cnfg = dflt.merge(
    REDIS_CONFIG[:development].symbolize_keys
  ) if REDIS_CONFIG[:development]
end


if Rails.env == 'development' && ENV['RUN_ON_HEROKU'].nil?
  $redis = Redis.new(cnfg)
else
  $redis = Redis.new(url: dflt[:host])
end
# #$redis_ns = Redis::Namespace.new(cnfg[:namespace], :redis => $redis) if cnfg[:namespace]

# # To clear out the db before each test
$redis.flushdb if Rails.env == 'test' || Rails.env == 'development'



# $redis.flushall if Rails.env == 'development'
