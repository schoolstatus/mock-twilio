# frozen_string_literal: true

require "rufus-scheduler"
require "active_support"
require "active_support/core_ext/time"
require "twilio-ruby"
require_relative "twilio/middleware/proxy"
require_relative "twilio/webhook_client"
require_relative "twilio/webhooks/base"
require_relative "twilio/webhooks/messages"
require_relative "twilio/webhooks/calls"
require_relative "twilio/webhooks/call_status_updates"
require_relative "twilio/webhooks/conferences"
require_relative "twilio/webhooks/customer_profiles"
require_relative "twilio/webhooks/brands"
require_relative "twilio/webhooks/inbound_messages"
require_relative "twilio/util/configuration"
require_relative "twilio/util/error_handler"
require_relative "twilio/util/generator"
require_relative "twilio/client"
require_relative "twilio/decorator"
require_relative "twilio/response"
require_relative "twilio/version"
require_relative "../twilio/rest/messaging/v1/service/phone_number_decorator"

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
