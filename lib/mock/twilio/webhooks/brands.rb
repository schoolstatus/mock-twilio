# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Brands < Base
        URL = "/webhooks/twilio/brands_compliance"
        EVENTS = { "verified": "registered", "unverified": "unverified" }

        def self.trigger(sid, status)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = data_builder(sid, status)

          signature = build_signature_for_request(request_url, data)

          response = webhook_client.request(Mock::Twilio.host,
                                            Mock::Twilio.port,
                                            'POST',
                                            URL,
                                            nil,
                                            data.to_json,
                                            headers.merge!({ 'X-Twilio-Signature': signature, 'Content-Type': 'application/json' }),
                                            auth_twilio,
                                            nil)
          case response.status
          when 200..204
            response
          when 400..600
            raise Webhooks::RestError, Mock::Twilio::ErrorHandler.new(response).raise
          end
        end

        def self.data_builder(sid, status)
          uuid = SecureRandom.uuid
          type = status
          [
            {
              specversion: "1.0",
              type: "com.twilio.messaging.compliance.brand-registration.brand-" + EVENTS[status.to_sym],
              source: uuid,
              id: uuid,
              datacontenttype: "application/json",
              time: Time.current.rfc2822,
              data: {
                accountsid: ::Twilio.account_sid,
                brandsid: sid,
                brandstatus: "registered",
                identitystatus: status
              }
            }
          ]
        end
      end
    end
  end
end
