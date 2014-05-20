# Config Redis

begin
  gem_dir_file = YAML.load_file("#{Rails.root}/config/sidekiq_pro_path.yml")
  $LOAD_PATH.unshift(gem_dir_file['path'])

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
