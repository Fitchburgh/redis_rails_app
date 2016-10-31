require 'redis'

# Redis.current = Redis.new(:host => 'redis-animate-53848')
uri = URI.parse(ENV["REDIS_URL"])
Redis.current = Redis.new(:url => uri)
