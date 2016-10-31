require 'redis'

# Redis.current = Redis.new(:host => 'redis-animate-53848')
uri = URI.parse(ENV["Redis.current_URL"])
Redis.current = Redis.new(:url => uri)
