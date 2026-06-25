# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  config.include RedisHelpers
  config.include AppConfigHelpers

  config.before do
    flush_test_redis!
    reload_app_dependencies!
  end

  config.before(:each, :proxy) do
    skip 'Set PROXY_TEST_URL to run proxy tests (e.g. http://localhost:3000)' unless ENV['PROXY_TEST_URL']
  end

  config.include AppHelpers, type: :request
  config.include ProxyHelpers, :proxy
end
