#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

set :stage, :production
set :deploy_to, '/var/www/fairnopoly'

server '78.109.61.168', user: 'deploy', roles: %w{web app db sidekiq}
server '78.109.61.169', user: 'deploy', roles: %w{web app sidekiq console}

set :branch, ENV['BRANCH_NAME'] || 'master'
