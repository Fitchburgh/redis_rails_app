require 'redis'

# REDIS = Redis.new(:host => 'redis-animate-53848')
uri = URI.parse(ENV["REDIS_URL"])
REDIS = Redis.new(:url => uri)
