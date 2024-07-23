# frozen_string_literal: true

require_relative "../decorators/messaging_v1/phone_number_list"
require_relative "../decorators/messaging_v1/phone_number_create"

module Mock
  module Twilio
    module Schemas
      class MessagingV1
        class << self
          RESOURCES = {
            phone_number_list: Mock::Twilio::Decorators::MessagingV1::PhoneNumberList,
            phone_number_create: Mock::Twilio::Decorators::MessagingV1::PhoneNumberCreate,
          }
          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/v1\/Services\/\w{34}\/PhoneNumbers$}
              return RESOURCES[:phone_number_list].decorate(body, request) if request.method == "GET"
              return RESOURCES[:phone_number_create].decorate(body, request) if request.method == "POST"
            end
          end
        end
      end
    end
  end
end
