# frozen_string_literal: true

module Mock
  module Twilio
    module Webhooks
      class Twiml < Base
        def self.trigger(sid, twiml, answered_by, call_status, body)
          # Wait simulation from twilio
          sleep DELAY.sample

          request_url = twiml
          url = twiml.split(Mock::Twilio.host).last

          data = call_status_updates_data(sid, answered_by, call_status, body)

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

        def self.call_status_updates_data(sid, answered_by, call_status, body)
          {
            :AccountSid=> twilio_client.account_sid,
            :ApiVersion=>	"2010-04-01",
            :CallbackSource=>	"call-progress-events",
            :CallDuration=>	"0",
            :Called=>	"+18222222222",
            :CalledCity=>	"TAMPA",
            :CalledCountry=> "US",
            :CalledState=> "FL",
            :CalledZip=> "33605",
            :Caller=>	"+18111111111",
            :CallerCity=> "no value",
            :CallerCountry=> "US",
            :CallerState=> "CA",
            :CallerZip=> "no value",
            :CallSid=> sid,
            :CallStatus=> call_status,
            :Direction=> "outbound-api",
            :Duration=> "0",
            :From=>	body["from"],
            :FromCity=> "no value",
            :FromCountry=> "US",
            :FromState=> "CA",
            :FromZip=> "no value",
            :SequenceNumber=> "2",
            :SipResponseCode=> "487",
            :Timestamp=> "2024-06-17 16:49:31 UTC",
            :To=>	body["to"],
            :ToCity=> "TAMPA",
            :ToCountry=> "US",
            :ToState=> "FL",
            :ToZip=> "33605",
            :StirStatus=> "B",
            :StirVerstat=> "TN-Validation-Passed-B",
            :AnsweredBy=> answered_by,
          }
        end
      end
    end
  end
end
