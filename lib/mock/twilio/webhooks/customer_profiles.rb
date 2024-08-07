# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class CustomerProfiles < Base
        URL = "/webhooks/twilio/customer_profiles_compliance"

        def self.trigger(sid, status)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = { :BundleSid=>sid, :Status=>status }

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
      end
    end
  end
end
