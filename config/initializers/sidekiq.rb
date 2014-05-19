# Config Redis

dir = File.dirname('/home/deploy/.rbenv/versions/2.1.0/lib/ruby/gems/2.1.0/gems/sidekiq-pro-1.7.1/lib/*')
$LOAD_PATH.unshift(dir)
begin
  require 'sidekiq-pro'
  require 'sidekiq/pro/reliable_push'
rescue LoadError
end

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://10.0.2.181:6379', namespace: 'fairnopoly' }
    begin
      require 'sidekiq/pro/reliable_fetch'
    rescue LoadError
    end
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://10.0.2.181:6379', namespace: 'fairnopoly' }
  end
end

Redis.current = SidekiqRedisConnectionWrapper.new
