# frozen_string_literal: true

module RateLimit
  module Track
    ALLOWED_FLAG = 1

    Outcome = Data.define(:allowed, :count, :retry_after) do
      def self.from_script(raw)
        flag, count, retry_after = raw
        new(allowed: flag == ALLOWED_FLAG, count:, retry_after:)
      end
    end
  end
end
