# frozen_string_literal: true

require 'sinatra'
require 'json'

require_relative 'lib/config'
require_relative 'lib/dependencies'
require_relative 'lib/api/error_handlers'
require_relative 'lib/api/json_responses'
require_relative 'lib/api/request_guards'

configure do
  set :bind, '0.0.0.0'
  set :port, Integer(ENV.fetch('PORT', 4567))
  set :config, AppConfig.load
  set :dependencies, Dependencies.new(settings.config)
end

register Api::ErrorHandlers
helpers Api::JsonResponses, Api::RequestGuards

before do
  content_type :json
end

get '/' do
  json_ok(
    {
      service: 'crawlbase-tracker',
      status: 'ok',
      endpoints: {
        health: { method: 'GET', path: '/health' },
        track: { method: 'POST', path: '/track', auth: 'X-Api-Token header' },
        stats: { method: 'GET', path: '/stats/:token' }
      }
    }
  )
end

# --- POST /track -------------------------------------------------------------
# Record a request for the given token and enforce the rate limit.

#   - Count this request against the token's current window in Redis.
#   - Within the limit (<= REQUEST_LIMIT): return 200 with the current count.
#   - Over the limit: return 429 with a JSON error and a Retry-After header.
#   - Choose and document your window strategy (fixed vs sliding).
#   - Think about atomicity: the counter must be correct under concurrent requests.

post '/track' do
  token = require_api_token!
  result = settings.dependencies.rate_limiter.track(token)

  render_track_response(result)
end

# --- GET /stats/:token -------------------------------------------------------
# Return the current request count and remaining quota for a token.
get '/stats/:token' do
  token = require_param!('token', error: 'Missing token')
  stats = settings.dependencies.rate_limiter.stats(token)

  json_ok(stats.to_h)
end

# --- GET /health (already implemented) ---------------------------------------
get '/health' do
  settings.dependencies.redis.ping
  json_ok({ status: 'ok' })
rescue Redis::BaseError
  halt 503, { status: 'unhealthy', error: 'redis unavailable' }.to_json
end
