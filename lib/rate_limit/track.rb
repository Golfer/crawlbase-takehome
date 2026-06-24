# frozen_string_literal: true

module RateLimit
  # Namespace for rate-limit tracking value objects and Redis script helpers.
  module Track
  end
end

require_relative 'track/outcome'
require_relative 'track/script'
require_relative 'track/result'
