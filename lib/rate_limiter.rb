# frozen_string_literal: true

require_relative 'rate_limit/policy'
require_relative 'rate_limit/store'
require_relative 'rate_limit/quota'
require_relative 'rate_limit/track/result'

# Public API for token-based sliding-window rate limiting.
class RateLimiter
  def initialize(redis, limit:, window:)
    @policy = RateLimit::Policy.new(limit:, window_seconds: window)
    @store = RateLimit::Store.new(redis:, policy: @policy)
  end

  def track(token)
    outcome = @store.track(token)
    RateLimit::Track::Result.for(policy: @policy, outcome:)
  end

  def stats(token)
    RateLimit::Quota.for(policy: @policy, count: @store.count(token))
  end
end
