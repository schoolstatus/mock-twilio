# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Messages < Base
        URL = "/api/v1/twilio_requests/webhook_message_updates"

        def self.trigger(sid)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = Mock::Twilio.proto + "://" + Mock::Twilio.forwarded_host + URL

          data = { :MessageSid=>sid, :MessageStatus=>"delivered" }

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
            raise Webhooks::RestError, response.body
          end
        end
      end
    end
  end
end
