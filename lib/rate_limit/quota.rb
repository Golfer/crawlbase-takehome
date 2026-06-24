# frozen_string_literal: true

module RateLimit
  Quota = Data.define(:count, :remaining, :limit, :window_seconds) do
    def to_h
      { count:, remaining:, limit:, window_seconds: }
    end

    def self.for(policy:, count:)
      new(
        count: count,
        remaining: policy.remaining_for(count),
        limit: policy.limit,
        window_seconds: policy.window_seconds
      )
    end
  end
end
