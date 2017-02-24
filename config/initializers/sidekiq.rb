#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
  Sidekiq::Client.reliable_push!
rescue LoadError, NoMethodError
end

# Try out database storage in Redis for staging
# http://www.mikeperham.com/2015/09/24/storing-data-with-redis/
redis_staging = { url: 'redis://10.0.2.181:6380/4' }
redis_production = { url: 'redis://10.0.2.181:6379', namespace: 'fairnopoly' }

Sidekiq.configure_server do |config|
  if Rails.env.staging?
    config.redis = redis_staging
  elsif Rails.env.production?
    config.redis = redis_production
  end

  begin
    config.reliable_fetch!
  rescue NoMethodError
  end
end

if Rails.env.staging?
  Sidekiq.configure_client do |config|
    config.redis = redis_staging
  end
elsif Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = redis_production
  end
end

Redis.current = SidekiqRedisConnectionWrapper.new
