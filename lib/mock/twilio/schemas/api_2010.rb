# frozen_string_literal: true

module Mock
  module Twilio
    module Schemas
      class Api2010
        class << self
          PAGES_KEYS = [
            "end",
            "first_page_uri",
            "next_page_uri",
            "last_page_uri",
            "page",
            "page_size",
            "previous_page_uri",
            "total",
            "num_pages",
            "start",
            "uri"
          ].freeze

          def decorate(body, request)
            body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
            body["date_sent"] = Time.current.rfc2822 if body["date_sent"]
            body["date_created"] = Time.current.rfc2822 if body["date_created"]
            body["start_time"] = Time.current.rfc2822 if body["start_time"]
            body["end_time"] = Time.current.rfc2822 if body["end_time"]

            message_type(body, request) if body["sid"]
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

          def message_type(body, request)
            sid = request.data["MediaUrl"] ? "MMtesting" : "SMtesting"
            body["sid"] = sid
          end
        end
      end
    end
  end
end
