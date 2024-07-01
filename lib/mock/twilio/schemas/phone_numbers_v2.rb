# frozen_string_literal: true

module Mock
  module Twilio
    module Schemas
      class PhoneNumbersV2
        class << self
          def for(body, request)
            body["calling_country_code"] = '1' if body["calling_country_code"]
            body["country_code"] = 'US' if body["country_code"]
            body["valid"] = true if body["valid"]
            body["validation_errors"] = [] if body["validation_errors"]
            body["line_type_intelligence"] = { "carrier_name" => "Mock::Twilio - SMS/MMS-SVR", "type" => "mock" }

            body
          end
        end
      end
    end
  end
end
