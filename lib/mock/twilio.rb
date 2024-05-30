# frozen_string_literal: true

require_relative "twilio/middleware/proxy"
require_relative "twilio/schemas/api_2010"
require_relative "twilio/schemas/messaging_v1"
require_relative "twilio/client"
require_relative "twilio/decorator"
require_relative "twilio/response"
require_relative "twilio/version"

module Mock
  module Twilio
    class Error < StandardError; end
  end
end
