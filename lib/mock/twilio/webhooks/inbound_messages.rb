# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class InboundMessages < Base
        URL = "/api/v1/twilio_requests/inbound"

        def self.trigger(sid, messaging_service_sid)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = inbound_data(sid, messaging_service_sid)

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

        def self.inbound_data(sid, messaging_service_sid)
          {
            "ToCountry": "US",
            "ToState": "MS",
            "SmsMessageSid": sid,
            "NumMedia": "0",
            "ToCity": "SARDIS",
            "FromZip": "98315",
            "SmsSid": sid,
            "FromState": "WA",
            "SmsStatus": "received",
            "FromCity": "SILVERDALE",
            "Body": "InboundMessage reply",
            "FromCountry": "US",
            "To": "+xxxxxx",
            "MessagingServiceSid": messaging_service_sid,
            "ToZip": "38666",
            "AddOns": "{\"status\":\"successful\",\"message\":null,\"code\":null,\"results\":{}}",
            "NumSegments": "1",
            "MessageSid": sid,
            "AccountSid": ::Twilio.account_sid,
            "From": "+yyyyyyy",
            "ApiVersion": "2010-04-01"
          }
        end
      end
    end
  end
end
