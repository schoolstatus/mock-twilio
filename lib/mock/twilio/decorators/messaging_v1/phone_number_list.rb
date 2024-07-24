# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module MessagingV1
        class PhoneNumberList
          class << self
            def decorate(body, request)
              phone_number_sid(body) if body["phone_numbers"].first["sid"]
              body["phone_numbers"].first["account_sid"] = ::Twilio.account_sid if body["phone_numbers"].first["account_sid"]
              parse_messaging_service_sid(body, request) if body["phone_numbers"].first["service_sid"]
              body["phone_numbers"].first["phone_number"] = "+19876543210" if body["phone_numbers"].first["phone_number"]
              body["phone_numbers"].first["country_code"] = "US" if body["phone_numbers"].first["country_code"]

              # Params for twilio pagination, needed for twilio-ruby serializers and absolute paths
              body["meta"]["key"] = "phone_numbers" if body["meta"]["key"]
              body["meta"]["page_size"] = 20 if body["meta"]["page_size"]
              body["meta"]["first_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]["first_page_url"]
              body["meta"]["previous_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]["previous_page_url"]
              body["meta"]["next_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=1" if body["meta"]["next_page_url"]
              body["meta"]["url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]["url"]

              body
            end

            def phone_number_sid(body)
              prefix = "PN"
              sid = prefix + SecureRandom.hex(16)
              body["phone_numbers"].first["sid"] = sid
            end

            def parse_messaging_service_sid(body, request)
              uri = URI(request.url)
              messaging_service_sid = uri.path.split('/')[3]
              body["phone_numbers"].first["service_sid"] = messaging_service_sid
            end
          end
        end
      end
    end
  end
end
