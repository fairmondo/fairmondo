namespace :memcached do
  desc 'Clears the Rails cache'
  task :flush => :environment do
    Rails.cache.clear
  end
end