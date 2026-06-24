require "sinatra"
require "redis"
require "json"

# --- Configuration -----------------------------------------------------------
set :bind, "0.0.0.0"
set :port, 4567

REQUEST_LIMIT  = 60   # requests allowed per token...
WINDOW_SECONDS = 60   # ...within this rolling window

# Redis connection. REDIS_URL is provided by docker-compose.
def redis
  @redis ||= Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379"))
end

# Read the API token from the request header (X-Api-Token).
def api_token
  request.env["HTTP_X_API_TOKEN"]
end

before do
  content_type :json
end

# --- POST /track -------------------------------------------------------------
# Record a request for the given token and enforce the rate limit.
post "/track" do
  token = api_token
  halt 400, { error: "Missing X-Api-Token header" }.to_json if token.nil? || token.empty?

  # TODO: implement rate limiting here.
  #   - Count this request against the token's current window in Redis.
  #   - Within the limit (<= REQUEST_LIMIT): return 200 with the current count.
  #   - Over the limit: return 429 with a JSON error and a Retry-After header.
  #   - Choose and document your window strategy (fixed vs sliding).
  #   - Think about atomicity: the counter must be correct under concurrent requests.

  halt 501, { error: "Not implemented" }.to_json
end

# --- GET /stats/:token -------------------------------------------------------
# Return the current request count and remaining quota for a token.
get "/stats/:token" do
  token = params["token"]

  # TODO: return the current count and remaining quota for this token
  #       in the active window.

  halt 501, { error: "Not implemented" }.to_json
end

# --- GET /health (already implemented) ---------------------------------------
get "/health" do
  { status: "ok" }.to_json
end
