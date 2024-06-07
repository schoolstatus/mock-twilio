# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Messages < Base
        URL = "/api/v1/twilio_requests/webhook_message_updates"

        def self.trigger
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = { :MessageSid=>"SMtesting", :MessageStatus=>"delivered" }

          signature = build_signature_for_request(request_url, data)

          webhook_client.request(Mock::Twilio.host,
                                 Mock::Twilio.port,
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
