# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Messages < Base
        def self.trigger(sid, callback_url)
          # Wait simulation from twilio
          sleep DELAY.sample

          if Mock::Twilio.webhook_message_status_url
            request_url = Mock::Twilio.webhook_message_status_url
            url = Mock::Twilio.webhook_message_status_url.split(Mock::Twilio.host).last
          elsif callback_url
            request_url = callback_url
            url = callback_url.split(Mock::Twilio.host).last
          else
            raise "There is not webhook_message_status_url or status_callback"
          end

          data = { :MessageSid=>sid, :MessageStatus=>"delivered" }

          signature = build_signature_for_request(request_url, data)

          response = webhook_client.request(Mock::Twilio.host,
                                            Mock::Twilio.port,
                                            'POST',
                                            url,
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
