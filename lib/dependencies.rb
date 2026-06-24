# frozen_string_literal: true

require 'redis'
require_relative 'config'
require_relative 'rate_limiter'

# Lazily wires Redis and the rate limiter from application config.
class Dependencies
  attr_reader :config

  def initialize(config = AppConfig.load)
    @config = config
  end

  def redis
    @redis ||= Redis.new(url: config.redis_url)
  end

  def rate_limiter
    @rate_limiter ||= RateLimiter.new(
      redis,
      limit: config.request_limit,
      window: config.window_seconds
    )
  end
end
