# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'rate limiting through nginx', :proxy do
  include ProxyHelpers

  def unique_token
    "proxy-#{SecureRandom.hex(6)}"
  end

  it 'serves /health through the proxy with the nginx header' do
    response = proxy_get('/health')

    expect(response.code).to eq('200')
    expect(response['X-Served-By']).to eq('nginx')
    expect(JSON.parse(response.body)).to eq('status' => 'ok')
  end

  it 'tracks a request through the proxy' do
    _response, body = proxy_track(unique_token)

    expect(body).to include('count', 'remaining', 'limit', 'window_seconds')
    expect(body['count']).to eq(1)
  end

  it 'returns 400 through the proxy when the token header is missing' do
    response = proxy_post('/track')

    expect(response.code).to eq('400')
    expect(JSON.parse(response.body)).to eq('error' => 'Missing X-Api-Token header')
  end

  it 'returns 429 through the proxy after the limit is exceeded' do
    token = unique_token
    limit = Integer(ENV.fetch('PROXY_REQUEST_LIMIT', 60))

    limit.times do
      response, body = proxy_track(token)
      expect(response.code).to eq('200')
      expect(body['limit']).to eq(limit)
    end

    response, body = proxy_track(token)

    expect(response.code).to eq('429')
    expect(response['Retry-After']).not_to be_nil
    expect(body).to include(
      'error' => 'Rate limit exceeded',
      'limit' => limit,
      'count' => limit
    )
  end

  it 'exposes stats through the proxy' do
    token = unique_token
    _response, track_body = proxy_track(token)

    response = proxy_get("/stats/#{token}")
    body = JSON.parse(response.body)

    expect(response.code).to eq('200')
    expect(body['count']).to eq(track_body['count'])
    expect(body['remaining']).to eq(track_body['remaining'])
  end
end
