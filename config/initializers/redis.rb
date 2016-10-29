require 'redis'

Redis.current = Redis.new(:host => 'localhost', :port => 6379)
