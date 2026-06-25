# frozen_string_literal: true

# Test defaults. Override via ENV when running specs (e.g. PROXY_TEST_URL).
ENV['RACK_ENV'] = 'test'
ENV['REDIS_URL'] ||= 'redis://localhost:6379/15'
ENV['REQUEST_LIMIT'] ||= '60'
ENV['WINDOW_SECONDS'] ||= '60'
