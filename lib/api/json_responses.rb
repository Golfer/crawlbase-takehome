# frozen_string_literal: true

module Api
  # JSON response helpers for Sinatra routes.
  module JsonResponses
    def json_ok(body, http_status: 200)
      status http_status
      body.to_json
    end

    def json_error(status, body)
      halt status, body.to_json
    end

    def render_track_response(result)
      if result.rate_limited?
        response.headers['Retry-After'] = result.retry_after.to_s
        json_error(429, result.to_error_h)
      else
        json_ok(result.to_h)
      end
    end
  end
end
