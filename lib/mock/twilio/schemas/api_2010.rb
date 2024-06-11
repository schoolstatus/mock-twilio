# frozen_string_literal: true

require_relative "../decorators/api_2010/messages"
require_relative "../decorators/api_2010/calls"

module Mock
  module Twilio
    module Schemas
      class Api2010
        class << self
          RESOURCES = {
            messages: Mock::Twilio::Decorators::Api2010::Messages,
            calls: Mock::Twilio::Decorators::Api2010::Calls,
          }

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

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/Messages.json}
              RESOURCES[:messages].decorate(body, request)
            when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/Calls.json}
              RESOURCES[:calls].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
