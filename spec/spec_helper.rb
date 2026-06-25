# frozen_string_literal: true

require_relative 'support/test_env'

%w[
  json
  net/http
  redis
  rspec
  rack/test
  securerandom
].each { |library| require library }

%w[
  redis_helpers
  app_config_helpers
  app_helpers
  proxy_helpers
  rate_limit_context
  rspec_config
].each { |support_file| require_relative "support/#{support_file}" }

require_relative '../app'
