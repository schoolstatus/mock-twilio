# frozen_string_literal: true

module Mock
  module Twilio
    module Schemas
      class MessagingV1
        class << self
          def decorate(body)
            # Params for twilio pagination, needed for twilio-ruby serializers and absolute paths
            body["meta"]["key"] = "phone_numbers" if body["meta"]
            body["meta"]["page_size"] = 20 if body["meta"]
            body["meta"]["first_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]
            body["meta"]["previous_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]
            body["meta"]["next_page_url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=1" if body["meta"]
            body["meta"]["url"] = "https://messaging.twilio.com/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=20&Page=0" if body["meta"]
            body
          end
        end
      end
    end
  end
end
