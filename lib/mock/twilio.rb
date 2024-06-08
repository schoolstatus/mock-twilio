# frozen_string_literal: true

require "rufus-scheduler"
require "active_support"
require "active_support/core_ext/time"
require_relative "twilio/middleware/proxy"
require_relative "twilio/schemas/api_2010"
require_relative "twilio/schemas/messaging_v1"
require_relative "twilio/webhook_client"
require_relative "twilio/webhooks/base"
require_relative "twilio/webhooks/messages"
require_relative "twilio/util/configuration"
require_relative "twilio/client"
require_relative "twilio/decorator"
require_relative "twilio/response"
require_relative "twilio/version"

module Mock
  module Twilio
    extend SingleForwardable

    def_delegators :configuration, :host, :forwarded_host, :port, :proto

    def self.configure(&block)
      yield configuration
    end

    def self.configuration
      @configuration ||= Util::Configuration.new
    end

    private_class_method :configuration
  end
end
