# frozen_string_literal: true

module Mock
  module Twilio
    module Services
      class CallService
        attr_reader :sid, :status_callback, :body

        def initialize(sid, status_callback, body)
          @sid = sid
          @status_callback = status_callback
          @body = body
        end

        def call
          response  = Mock::Twilio::Webhooks::Calls.trigger(sid, status_callback, 'ringing', body)

          Mock::Twilio::Webhooks::Calls.trigger(sid, status_callback, 'completed', body) if response.success?
        end
      end
    end
  end
end
