# Source: http://blog.dylangriff.in/2013/09/28/using-sidekiqs-redis-connections-in-other-places/
# Because +Sidekiq.redis+ requires passing a block,
# we can't pass it straight to +Redis::Semaphore+.
# This class simply delegates every method call to
# the Sidekiq connection.
class SidekiqRedisConnectionWrapper
  def self.redis
    Sidekiq.redis { |conn| conn }
  end

  def method_missing(meth, *args, &block)
    Sidekiq.redis do |connection|
      connection.send(meth, *args, &block)
    end
  end

  def respond_to_missing?(meth)
    Sidekiq.redis do |connection|
      connection.respond_to?(meth)
    end
  end
end