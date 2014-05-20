# Config Redis


# This code is responsible for loading the sidekiq-pro gem, which is NOT installed
# via bundler
begin
  file = YAML.load_file("#{Rails.root}/config/sidekiq_pro_path.yml")
  path = file['path']
  $LOAD_PATH.unshift(path)
rescue
  puts 'sidekiq_pro_path.yml not found'
end

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
