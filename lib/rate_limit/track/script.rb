# frozen_string_literal: true

module RateLimit
  module Track
    class Script
      SOURCE = File.read(File.join(__dir__, 'script.lua'), freeze: true).freeze

      def self.load_into(redis)
        new(redis, redis.script(:load, SOURCE))
      end

      def initialize(redis, sha)
        @redis = redis
        @sha = sha
      end

      def call(key:, now:, window_seconds:, limit:, member:)
        @redis.evalsha(
          @sha,
          keys: [key],
          argv: [now, window_seconds, limit, member]
        )
      end
    end
  end
end
