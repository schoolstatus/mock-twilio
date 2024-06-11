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

              body
            end

            def call_sid(body, request)
              prefix = "CA"
              sid = prefix + SecureRandom.hex(16)
              body["sid"] = sid
            end
          end
        end
      end
    end
  end
end
