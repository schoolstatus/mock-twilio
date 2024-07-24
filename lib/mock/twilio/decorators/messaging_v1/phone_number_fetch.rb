# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module MessagingV1
        class PhoneNumberFetch
          class << self
            include Mock::Twilio::Generator

            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]

              parse_messaging_phone_number_sid(body, request) if body["sid"]
              parse_messaging_service_sid(body, request) if body["service_sid"]

              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]
              body["country_code"] = "US" if body["country_code"]
              body["capabilities"] = [] if body["capabilities"]
              body["phone_number"] = phone_number_generator if body["phone_number"]

              body
            end

            def parse_messaging_phone_number_sid(body, request)
              uri = URI(request.url)
              phone_number_sid = uri.path.split('/')[5]
              body["sid"] = phone_number_sid
            end

            def parse_messaging_service_sid(body, request)
              uri = URI(request.url)
              messaging_service_sid = uri.path.split('/')[3]
              body["service_sid"] = messaging_service_sid
            end
          end
        end
      end
    end
  end
end
