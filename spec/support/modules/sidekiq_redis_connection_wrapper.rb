class SidekiqRedisConnectionWrapper
  def new
    Redis.new db: 15 # use database 15 for testing so we dont accidentally step on your real data
    # Inspired by https://github.com/dv/redis-semaphore/blob/master/spec/semaphore_spec.rb
  end
end