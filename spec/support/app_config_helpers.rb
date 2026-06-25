# frozen_string_literal: true

module AppConfigHelpers
  def reload_app_dependencies!
    Sinatra::Application.set :config, AppConfig.load
    Sinatra::Application.set :dependencies, Dependencies.new(Sinatra::Application.settings.config)
  end

  def with_env(overrides)
    original = overrides.to_h { |key, _| [key.to_s, ENV.fetch(key.to_s, nil)] }
    overrides.each { |key, value| ENV[key.to_s] = value }
    reload_app_dependencies!
    yield
  ensure
    original.each { |key, value| ENV[key] = value }
    reload_app_dependencies!
  end
end
