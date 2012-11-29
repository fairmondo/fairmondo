##### Requirement's #####
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

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
set :repository, "git://gitorious.org/fairnopoly/fairnopoly.git"

##### Additional Settings #####
#set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

#### Roles #####
# See Stages

##### Overwritten and changed default capistrano tasks #####
namespace :deploy do

  # Restart Application
  desc "Restart RailsApp"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Additional Symlinks"
  task :additional_symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/actionmailer.yml #{release_path}/config/actionmailer.yml"
  end

  desc "Addtional Rake Tasks"
  task :additional_rake, :roles => :app, :only => {:primary => true} do

  end

end
  
##### After and Before Tasks #####
before "deploy:assets:precompile", "deploy:additional_symlink"
after "deploy", "deploy:additional_rake"
after "deploy:restart", "deploy:cleanup"




