# frozen_string_literal: true

module RateLimit
  # Computes Retry-After seconds from the oldest request in a sliding window.
  module RetryAfter
    module_function

    def from_oldest(oldest_timestamp:, window:, now:)
      return 0 if oldest_timestamp.nil?

      wait = (oldest_timestamp + window - now).ceil
      [wait, 1].max
    end
  end
end
