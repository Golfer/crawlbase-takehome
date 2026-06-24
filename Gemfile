# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~>3.3.0'

gem 'puma', '~> 6.4'
gem 'rackup', '~> 2.1' # required to run Sinatra on Rack 3+
gem 'redis', '~> 5.2'
gem 'sinatra', '~> 4.0'

group :test do
  gem 'rack-test', '~> 2.1'
  gem 'rspec', '~> 3.13'
end

group :development, :test do
  gem 'rubocop', require: false
end
