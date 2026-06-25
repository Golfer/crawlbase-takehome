# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'POST /track', type: :request do
  include AppHelpers

  include_context 'with rate limit'

  def track(token)
    post '/track', nil, { 'HTTP_X_API_TOKEN' => token }
  end

  it 'returns 400 when X-Api-Token is missing' do
    post '/track'

    expect(last_response.status).to eq(400)
    expect(json_response).to eq('error' => 'Missing X-Api-Token header')
  end

  it 'returns quota details for allowed requests' do
    track('token-a')

    expect(last_response.status).to eq(200)
    expect(json_response).to include(
      'count' => 1,
      'remaining' => 2,
      'limit' => 3,
      'window_seconds' => 60
    )
  end

  it 'enforces the limit per token' do
    3.times { track('token-a') }
    track('token-a')

    expect(last_response.status).to eq(429)
    expect(last_response.headers['Retry-After']).not_to be_nil
    expect(json_response).to include(
      'error' => 'Rate limit exceeded',
      'limit' => 3,
      'count' => 3
    )
  end

  it 'tracks tokens independently' do
    3.times { track('token-a') }
    track('token-b')

    expect(last_response.status).to eq(200)
    expect(json_response['count']).to eq(1)
  end
end

RSpec.describe 'GET /stats/:token', type: :request do
  include AppHelpers

  include_context 'with rate limit'

  it 'returns the current quota for a token' do
    post '/track', nil, { 'HTTP_X_API_TOKEN' => 'stats-token' }

    get '/stats/stats-token'

    expect(last_response.status).to eq(200)
    expect(json_response).to include(
      'count' => 1,
      'remaining' => 2,
      'limit' => 3,
      'window_seconds' => 60
    )
  end
end
