# frozen_string_literal: true

module Mock
  module Twilio
    class ErrorHandler
      def initialize(response)
        @response = response
      end

      def raise
        return @response.body if @response.headers["content-type"].include?("application/json")

        @response.reason_phrase
      end
    end
  end
end
