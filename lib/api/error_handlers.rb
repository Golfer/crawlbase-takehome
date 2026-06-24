# frozen_string_literal: true

module Api
  # Registers Sinatra error handlers for dependency failures.
  module ErrorHandlers
    def self.registered(app)
      app.error Redis::BaseError do
        halt 503, {
          error: 'Rate limit storage unavailable',
          detail: env['sinatra.error'].message
        }.to_json
      end
    end
  end
end
