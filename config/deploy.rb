#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
##### Requirement's #####
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require "sidekiq/capistrano"

#### Use the asset-pipeline
load 'deploy/assets'

##### Stages #####
set :stages, %w(production staging)

##### Constant variables #####
set :application, "fairnopoly"
set :deploy_to,   "/var/www/#{application}"
set :user, "deploy"
set :use_sudo, false


##### Default variables #####
set :keep_releases, 10

##### Repository Settings #####
set :scm,        :git
set :repository, "git://github.com/fairnopoly/fairnopoly.git"

##### Additional Settings #####
#set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

# Sidekiq Workers
set :sidekiq_role, :sidekiq



#### Roles #####
# See Stages

desc "tail log files"
task :log, :roles => :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

##### Overwritten and changed default capistrano tasks #####
namespace :deploy do

  # Restart Application
  desc "Restart RailsApp"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Additional Symlinks"
  task :additional_symlink, :roles => [:app,:sidekiq]  do
    run "ln -nfs #{shared_path}/data/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/data/config/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -nfs #{shared_path}/data/config/actionmailer.yml #{release_path}/config/actionmailer.yml"
    run "ln -nfs #{shared_path}/data/config/api.yml #{release_path}/config/api.yml"
    run "ln -nfs #{shared_path}/data/config/email_addresses.yml #{release_path}/config/email_addresses.yml"
    run "ln -nfs #{shared_path}/data/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/data/system #{release_path}/public/system"
    run "ln -nfs #{shared_path}/data/solr/data #{release_path}/solr/data"
  end

  desc "Addtional Rake Tasks"
  task :additional_rake, :roles => :app, :only => {:primary => true} do

  end

  desc 'Prompts if new migrations are available and runs them if you want to'
  task :needs_migrations, :roles => :db, :only => {:primary => true} do
    migrations_changed = if previous_release.nil?
      true # propably first deploy, so no migrations to compare
    else
      old_rev = capture("cd #{previous_release} && git log --pretty=format:'%H' -n 1 | cat").strip
      new_rev = capture("cd #{latest_release} && git log --pretty=format:'%H' -n 1 | cat").strip
      capture("cd #{latest_release} && git diff #{old_rev} #{new_rev} --name-only | cat").include?('db/migrate')
    end
    if migrations_changed && Capistrano::CLI.ui.ask("New migrations pending. Enter 'yes' to run db:migrate") == 'yes'
      migrate
    end
  end
end

namespace :import do
  desc "Import content"
  task :content do
    run "mkdir -p #{shared_path}/uploads"
    file_name = Time.now.utc.strftime("%Y%m%d%H%M%S")
    upload "#{ARGV[2]}", "#{shared_path}/uploads/#{file_name}.csv"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake import:content #{shared_path}/uploads/#{file_name}.csv"
  end
end

##### After and Before Tasks #####
before "deploy:assets:precompile", "deploy:additional_symlink"
after "deploy", "deploy:additional_rake"
after "deploy:restart", "deploy:cleanup"
after 'deploy:update_code', 'deploy:needs_migrations'

