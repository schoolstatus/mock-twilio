# frozen_string_literal: true

require_relative "twilio/middleware/proxy"
require_relative "twilio/schemas/api_2010"
require_relative "twilio/schemas/messaging_v1"
require_relative "twilio/webhook_client"
require_relative "twilio/webhooks/base"
require_relative "twilio/webhooks/messages"
require_relative "twilio/client"
require_relative "twilio/decorator"
require_relative "twilio/response"
require_relative "twilio/version"

module Mock
  module Twilio
    class Error < StandardError; end
  end
end
