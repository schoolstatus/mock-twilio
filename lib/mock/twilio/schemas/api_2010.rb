# frozen_string_literal: true

require_relative "../decorators/api_2010/messages"
require_relative "../decorators/api_2010/calls"
require_relative "../decorators/api_2010/conferences_participants_update"
require_relative "../decorators/api_2010/conferences_participants_create"
require_relative "../decorators/api_2010/addresses"

module Mock
  module Twilio
    module Schemas
      class Api2010
        class << self
          RESOURCES = {
            messages: Mock::Twilio::Decorators::Api2010::Messages,
            calls: Mock::Twilio::Decorators::Api2010::Calls,
            conferences_participants_update: Mock::Twilio::Decorators::Api2010::ConferencesParticipantsUpdate,
            conferences_participants_create: Mock::Twilio::Decorators::Api2010::ConferencesParticipantsCreate,
            addresses: Mock::Twilio::Decorators::Api2010::Addresses,
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
            when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/Conferences/[A-Za-z0-9]+/Participants/[A-Za-z0-9]+.json}
              RESOURCES[:conferences_participants_update].decorate(body, request)
            when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/Conferences/[A-Za-z0-9]+/Participants.json}
              RESOURCES[:conferences_participants_create].decorate(body, request)
            when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/Addresses.json}
              RESOURCES[:addresses].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
