
require 'torquebox-capistrano-support'
require "rvm/capistrano"
require "bundler/capistrano"

ssh_options[:forward_agent] = true
default_environment['JRUBY_HOME'] = "/home/fairnopoly/.rvm/rubies/jruby-1.6.7/"
default_environment['RAILS_ENV'] = "production"

# SCM
set :application,       "fairnopoly"
set :repository,        "https://git.gitorious.org/fairnopoly/fairnopoly.git"
set :branch,            "master"
set :user,              "fairnopoly"
set :scm,               :git
set :scm_verbose,       true
set :use_sudo,          false
set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false
set :jruby_home,        '/home/fairnopoly/.rvm/rubies/jruby-1.6.7/'
set :app_ruby_version, '1.9'

#RVM 
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    

#set :rvm_ruby_string, 'jruby'
#set :rvm_type, :user  # Don't use system-wide RVM

# Production server
set :deploy_to,         "/home/fairnopoly/deployment"
set :torquebox_home,    "/home/fairnopoly/torquebox"
set :jboss_init_script, "/etc/init.d/fairnopoly"
#set :app_environment,   "RAILS_ENV: production"
set :app_context,       "/"

ssh_options[:forward_agent] = false

role :web, "78.47.60.75"
role :app, "78.47.60.75"
role :db,  "78.47.60.75", :primary => true 

after 'deploy:update_code', 'deploy:symlink_db'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end
