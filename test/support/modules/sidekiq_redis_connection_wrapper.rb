#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class SidekiqRedisConnectionWrapper
  def new
    Redis.new db: 15 # use database 15 for testing so we dont accidentally step on your real data
    # Inspired by https://github.com/dv/redis-semaphore/blob/master/spec/semaphore_spec.rb
  end
end
