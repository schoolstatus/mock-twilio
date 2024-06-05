# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Base
        HOST = "http://shunkan-ido-service"
        FORWARDED_HOST = "finally-handy-vulture.ngrok-free.app"
        PORT = "3000"
        PROTO = "http"
        DELAY = [0.5, 0.8]

        def self.build_signature_for_request(request_url, params)
          validator = ::Twilio::Security::RequestValidator.new(::Twilio.auth_token)
          validator.build_signature_for(request_url, params)
        end

        def self.twilio_client
          ::Twilio::REST::Client.new
        end

        def self.webhook_client
          Mock::Twilio::WebhooksClient.new
        end

        def self.auth_twilio
          [twilio_client.account_sid, twilio_client.auth_token]
        end

        def self.headers
          {
            'X-Forwarded-Proto': PROTO,
            'Host': FORWARDED_HOST
          }
        end
      end
    end
  end
end
