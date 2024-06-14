# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter '/test/'
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "mock/twilio"
require "twilio-ruby"

require "minitest/autorun"
require 'webmock/minitest'
require "pry"

Twilio.configure do |config|
  config.account_sid = "ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
  config.auth_token = "SKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
end

Mock::Twilio.configure do |config|
  config.host = "http://shunkan-ido-service"
  config.forwarded_host = "forwarded_host.app"
  config.port = "3000"
  config.proto = "http"
end
