# frozen_string_literal: true

module AppHelpers
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def json_response
    JSON.parse(last_response.body)
  end
end
