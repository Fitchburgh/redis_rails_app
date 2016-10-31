require 'redis'

Redis.current = Redis.new(:host => 'redis-animate-53848')
