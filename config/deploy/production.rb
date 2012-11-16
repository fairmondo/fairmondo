role :app, "78.109.61.168", :primary => true
role :app, "78.109.61.169"
role :web, "78.109.61.168", :primary => true
role :web, "78.109.61.169"
role :db, "78.109.61.168", :primary => true

set :rails_env, "production"
set :branch, "master"
