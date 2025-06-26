# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Voicemail < Base
        URL = "/api/v1/twilio_calls/create_voicemail"

        def self.trigger(call_sid, rec_sid)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = voicemail_data(call_sid, rec_sid)

          signature = build_signature_for_request(request_url, data)

          response = webhook_client.request(Mock::Twilio.host,
                                            Mock::Twilio.port,
                                            'POST',
                                            URL,
                                            nil,
                                            data,
                                            headers.merge!({ 'X-Twilio-Signature': signature }),
                                            auth_twilio,
                                            nil)
          case response.status
          when 200..204
            response
          when 400..600
            raise Webhooks::RestError, Mock::Twilio::ErrorHandler.new(response).raise
          end
        end

        def self.voicemail_data(call_sid, rec_sid)
          {
            :RecordingSource=> "RecordVerb",
            :RecordingSid=> rec_sid,
            :RecordingUrl=> "https://cdn.pixabay.com/download/audio/2022/03/24/audio_4ff823c44c.mp3?filename=ding-101492.mp3",
            :RecordingStatus=> "completed",
            :RecordingChannels=> "1",
            :ErrorCode=> "0",
            :CallSid=> call_sid,
            :RecordingStartTime=> Time.current.rfc2822,
            :AccountSid=> twilio_client.account_sid,
            :RecordingDuration=> "4"
          }
        end
      end
    end
  end
end
