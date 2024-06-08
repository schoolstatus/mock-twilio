# frozen_string_literal: true

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
