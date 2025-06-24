# frozen_string_literal: true

module Mock
  module Twilio
    module Services
      class CallService
        attr_reader :sid, :status_callback

        def initialize(sid, status_callback)
          @sid = sid
          @status_callback = status_callback
        end

        def call
          response  = Mock::Twilio::Webhooks::Calls.trigger(sid, 'ringing') if conference_response.success?
          Mock::Twilio::Webhooks::Calls.trigger(sid, 'completed') if response.success?
        end
      end
    end
  end
end
