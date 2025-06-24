# frozen_string_literal: true

module Mock
  module Twilio
    module Services
      class ConferenceCallService
        attr_reader :sid, :twiml, :status_callback, :body

        def initialize(sid, twiml, status_callback, body)
          @sid = sid
          @twiml = twiml
          @status_callback = status_callback
          @body = body
        end

        def call
          response = Mock::Twilio::Webhooks::Twiml.trigger(sid, twiml, 'unknown', 'ringing')

          conference_response = if response.success?
                                  twiMl_xml = Nokogiri::XML response.body
                                  friendly_name = twiMl_xml.at_xpath('//Dial').at_xpath('//Conference').children.text
                                  Mock::Twilio::Webhooks::Conferences.trigger(friendly_name)
                                end

          # Participant
          participant_ringing   = Mock::Twilio::Webhooks::Calls.trigger(sid, 'ringing') if conference_response.success?
          participant_completed = Mock::Twilio::Webhooks::Calls.trigger(sid, 'completed') if participant_ringing.success?

          call_completed = Mock::Twilio::Webhooks::Twiml.trigger(sid, twiml, 'human', 'completed') if participant_completed.success?
          Mock::Twilio::Webhooks::Voicemail.trigger(sid) if call_completed.success? && [true, false].sample
        end
      end
    end
  end
end
