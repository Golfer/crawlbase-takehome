# frozen_string_literal: true

require 'securerandom'

require_relative 'track/outcome'
require_relative 'track/script'

module RateLimit
  # Sliding-window storage in Redis (sorted sets).
  # Writes go through Track::Script (atomic); reads prune expired entries then count.
  class Store
    def initialize(redis:, policy:)
      @redis = redis
      @policy = policy
      @script = Track::Script.load_into(redis)
    end

    def track(token)
      now = Time.now.to_f

      raw = @script.call(
        key: @policy.rate_key(token),
        now: now,
        window_seconds: @policy.window_seconds,
        limit: @policy.limit,
        member: unique_member(now)
      )

      Track::Outcome.from_script(raw)
    end

    def count(token)
      key = @policy.rate_key(token)
      now = Time.now.to_f

      prune_expired(key, now)
      @redis.zcard(key)
    end

    private

    def prune_expired(key, now)
      @redis.zremrangebyscore(key, 0, now - @policy.window_seconds)
    end

    def unique_member(now)
      "#{now}:#{SecureRandom.hex(8)}"
    end
  end
end
