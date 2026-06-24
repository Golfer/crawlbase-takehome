# frozen_string_literal: true

module Api
  # Request validation helpers for required headers and params.
  module RequestGuards
    def require_api_token!
      token = request.get_header('HTTP_X_API_TOKEN')
      json_error(400, error: 'Missing X-Api-Token header') if token.nil? || token.empty?

      token
    end

    def require_param!(name, error:)
      value = params[name]
      json_error(400, error:) if value.nil? || value.empty?

      value
    end
  end
end
