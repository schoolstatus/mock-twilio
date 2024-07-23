# frozen_string_literal: true

require_relative "../decorators/messaging_v1/phone_number_list"
require_relative "../decorators/messaging_v1/phone_number_create"
require_relative "../decorators/messaging_v1/phone_number_fetch"

module Mock
  module Twilio
    module Schemas
      class MessagingV1
        class << self
          RESOURCES = {
            phone_number_list: Mock::Twilio::Decorators::MessagingV1::PhoneNumberList,
            phone_number_create: Mock::Twilio::Decorators::MessagingV1::PhoneNumberCreate,
            phone_number_fetch: Mock::Twilio::Decorators::MessagingV1::PhoneNumberFetch,
          }
          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/v1\/Services\/\w{34}\/PhoneNumbers$}
              return RESOURCES[:phone_number_list].decorate(body, request) if request.method == "GET"
              return RESOURCES[:phone_number_create].decorate(body, request) if request.method == "POST"
            when %r{\/v1\/Services\/\w{34}\/PhoneNumbers\/\w{34}}
              RESOURCES[:phone_number_fetch].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
