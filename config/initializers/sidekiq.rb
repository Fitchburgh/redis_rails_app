Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://h:peouqndvghr88kcpk7h64u4194p@ec2-54-225-80-250.compute-1.amazonaws.com:10279' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://h:peouqndvghr88kcpk7h64u4194p@ec2-54-225-80-250.compute-1.amazonaws.com:10279' }
end
