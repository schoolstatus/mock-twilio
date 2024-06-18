# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class Messages
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_sent"] = Time.current.rfc2822 if body["date_sent"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["start_time"] = Time.current.rfc2822 if body["start_time"]
              body["end_time"] = Time.current.rfc2822 if body["end_time"]

              message_sid(body, request) if body["sid"]
              pagination(body) if body["available_phone_numbers"]

              body
            end

            def pagination(body)
              # Params returned in mock_server but not on real twilio request for the moment.
              # Not needed for us now.
              PAGES_KEYS.each do |key|
                body.delete(key) if body[key]
              end
            end

            def message_sid(body, request)
              prefix = request.data["MediaUrl"] ? "MM" : "SM"
              sid = prefix + SecureRandom.hex(16)
              scheduler = Rufus::Scheduler.new
              scheduler.in '2s' do
                Mock::Twilio::Webhooks::Messages.trigger(sid)
              end
              body["sid"] = sid
            end
          end
        end
      end
    end
  end
end
