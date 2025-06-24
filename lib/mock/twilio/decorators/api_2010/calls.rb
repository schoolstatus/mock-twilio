# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class Calls
          @@scheduler = Rufus::Scheduler.new

          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_sent"] = Time.current.rfc2822 if body["date_sent"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["start_time"] = Time.current.rfc2822 if body["start_time"]
              body["end_time"] = Time.current.rfc2822 if body["end_time"]

              call_sid(body, request) if body["sid"]
              phone_number_sid(body, request) if body["phone_number_sid"]
              body["direction"] = "outbound-api" if body["direction"]
              body["api_version"] = "2010-04-01" if body["api_version"]
              body["to"] = request.data['To'] if body["to"]
              body["from"] = request.data['From'] if body["from"]

              body
            end

            def call_sid(body, request)
              prefix = "CA"
              sid = prefix + SecureRandom.hex(16)
              @@scheduler.in '2s' do
                # https://www.twilio.com/docs/voice/api/call-resource#create-a-call-resource
                # The absolute URL that returns the TwiML instructions for the call
                conference_uuid = request.data["Url"].split("conference_uuid=").last if request.data["Url"]
                twiml_action = conference_uuid ? "conference" : "call"

                status_callback = request.data["StatusCallback"] if request.data["StatusCallback"]

                case twiml_action
                when "conference"
                  twiml = request.data["Url"]
                  service = ConferenceCallService.new(sid, twiml, status_callback, body)
                when "call"
                  twiml_url = request.data["TwiML"]
                  service = CallService.new(sid, status_callback, body)
                end

                begin
                  service.call
                rescue  => e
                  puts e
                end
              end
              body["sid"] = sid
            end

            def phone_number_sid(body, request)
              prefix = "PN"
              sid = prefix + SecureRandom.hex(16)
              body["phone_number_sid"] = sid
            end
          end
        end
      end
    end
  end
end
