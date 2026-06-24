# frozen_string_literal: true

module RateLimit
  # Encapsulates per-token rate limit keys and quota calculations.
  class Policy
    attr_reader :limit, :window_seconds

    def initialize(limit:, window_seconds:)
      @limit = limit
      @window_seconds = window_seconds
    end

    def rate_key(token)
      "rate:#{token}"
    end

    def exhausted?(count)
      count >= limit
    end

    def remaining_for(count)
      [limit - count, 0].max
    end
  end
end
