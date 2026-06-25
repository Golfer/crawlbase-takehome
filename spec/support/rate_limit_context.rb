# frozen_string_literal: true

RSpec.shared_context 'with rate limit' do |limit: 3, window_seconds: 60|
  include AppConfigHelpers

  around do |example|
    with_env('REQUEST_LIMIT' => limit.to_s, 'WINDOW_SECONDS' => window_seconds.to_s, &example)
  end
end
