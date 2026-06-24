# frozen_string_literal: true

require_relative '../quota'

module RateLimit
  module Track
    Result = Data.define(:quota, :allowed, :retry_after) do
      def allowed? = allowed
      def rate_limited? = !allowed

      def to_h
        quota.to_h
      end

      def to_error_h
        {
          error: 'Rate limit exceeded',
          limit: quota.limit,
          count: quota.count,
          retry_after: retry_after
        }
      end

      def self.for(policy:, outcome:)
        new(
          quota: Quota.for(policy:, count: outcome.count),
          allowed: outcome.allowed,
          retry_after: outcome.retry_after
        )
      end

      def count = quota.count
      def remaining = quota.remaining
      def limit = quota.limit
      def window_seconds = quota.window_seconds
    end
  end
end
