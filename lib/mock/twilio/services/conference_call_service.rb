# frozen_string_literal: true

module Mock
  module Twilio
    module Services
      class ConferenceCallService
        attr_reader :sid, :twiml, :status_callback, :body
        include Mock::Twilio::Generator

        def initialize(sid, twiml, status_callback, body)
          @sid = sid
          @twiml = twiml
          @status_callback = status_callback
          @body = body
        end

        def call
          response = Mock::Twilio::Webhooks::Twiml.trigger(sid, twiml, 'unknown', 'ringing', body)

          conference_response = if response.success?
                                  twiMl_xml = ::Nokogiri::XML response.body
                                  friendly_name = twiMl_xml.at_xpath('//Dial').at_xpath('//Conference').children.text
                                  conf_sid = random_conference_sid
                                  Mock::Twilio::Webhooks::Conferences.trigger(friendly_name, conf_sid)
                                end

          # Participant
          participant_ringing   = Mock::Twilio::Webhooks::Calls.trigger(sid, status_callback, 'ringing', body) if conference_response.success?
          participant_completed = Mock::Twilio::Webhooks::Calls.trigger(sid, status_callback, 'completed', body) if participant_ringing.success?

          call_completed = Mock::Twilio::Webhooks::Twiml.trigger(sid, twiml, 'human', 'completed', body) if participant_completed.success?
          if call_completed.success? && [true, false].sample
            rec_sid = random_voicemail_sid
            Mock::Twilio::Webhooks::Voicemail.trigger(sid, rec_sid)
          else
            call_completed
          end
        end
      end
    end
  end
end
