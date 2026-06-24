# frozen_string_literal: true

AppConfig = Data.define(:request_limit, :window_seconds, :redis_url) do
  def self.load
    new(
      request_limit: Integer(ENV.fetch('REQUEST_LIMIT', 60)),
      window_seconds: Integer(ENV.fetch('WINDOW_SECONDS', 60)),
      redis_url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')
    )
  end
end
