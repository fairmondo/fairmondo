set :stage, :production

server '78.109.61.168', user: 'deploy', roles: %w{web app db}
server '78.109.61.169', user: 'deploy', roles: %w{web app}
server '78.109.59.254', user: 'deploy', roles: %w{web app}
server '5.22.150.182', user: 'deploy', roles: %w{sidekiq console}

set :branch, ENV["BRANCH_NAME"] || "master"

set :sidekiq_processes, ->{ 2 }