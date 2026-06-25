# frozen_string_literal: true

module RedisHelpers
  def test_redis
    @test_redis ||= Redis.new(url: ENV.fetch('REDIS_URL'))
  end

  def flush_test_redis!
    test_redis.flushdb
  end
end
