# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Conferences < Base
        URL = "/api/v1/twilio_calls/conference_status_changes"

        def self.trigger(friendly_name, sid)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = conference_data(friendly_name, sid)

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

        def self.conference_data(friendly_name, sid)
          prefix = "CF"
          {
           :FriendlyName=> friendly_name,
           :SequenceNumber=> "6",
           :ConferenceSid=> sid,
           :StatusCallbackEvent=> "conference-end",
           :Timestamp=> "2024-06-17 16:49:31 UTC",
           :AccountSid=> twilio_client.account_sid,
           :Reason=> "Participant from mock twilio"
          }
        end
      end
    end
  end
end
