# frozen_string_literal: true

module ProxyHelpers
  JSON_HEADERS = { 'Content-Type' => 'application/json' }.freeze

  def proxy_base_url
    ENV.fetch('PROXY_TEST_URL').chomp('/')
  end

  def proxy_get(path, headers: {})
    proxy_request(:get, path, headers:)
  end

  def proxy_post(path, headers: {})
    proxy_request(:post, path, headers: JSON_HEADERS.merge(headers))
  end

  def proxy_track(token)
    response = proxy_post('/track', headers: { 'X-Api-Token' => token })
    [response, JSON.parse(response.body)]
  end

  private

  def proxy_request(method, path, headers: {})
    uri = URI("#{proxy_base_url}#{path}")
    request = Net::HTTP.const_get(method.capitalize).new(uri)
    headers.each { |key, value| request[key] = value }

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
