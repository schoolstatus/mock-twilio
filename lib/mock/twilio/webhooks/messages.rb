# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Messages < Base
        URL = "/api/v1/twilio_requests/webhook_message_updates"

        def self.trigger
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = PROTO + "://" + FORWARDED_HOST + URL
          data = { :test=>'test' }

          signature = build_signature_for_request(request_url, data)

          webhook_client.request(HOST,
                                 PORT,
                                 'POST',
                                 URL,
                                 nil,
                                 data,
                                 headers.merge!({ 'X-Twilio-Signature': signature }),
                                 auth_twilio,
                                 nil)
        end
      end
    end
  end
end
