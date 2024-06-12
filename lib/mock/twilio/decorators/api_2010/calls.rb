# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class Calls
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
              scheduler = Rufus::Scheduler.new
              scheduler.in '2s' do
                Mock::Twilio::Webhooks::Calls.trigger(sid)
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
