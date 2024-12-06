# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class AvailablePhoneNumbersLocal
          class << self
            include Mock::Twilio::Generator

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
              PAGES_KEYS.each do |key|
                body.delete(key) if body.key?(key)
              end

              body["available_phone_numbers"].each do |number|
                number["address_requirements"] = "none"
                number["friendly_name"] = friendly_number_generator
                number["iso_country"] = "US"
                number["lata"] = rand(100..999).to_s
                number["latitude"] = random_latitude.to_s
                number["longitude"] = random_longitude.to_s
                number["locality"] = "Hilo"
                number["postal_code"] = rand(10000..99999).to_s
                number["rate_center"] = "HILO"
                number["region"] = "HI"
                number["phone_number"] = phone_number_generator
              end

              body["uri"] = "/2010-04-01/Accounts/#{::Twilio.account_sid}/AvailablePhoneNumbers/US/Local.json"

              body
            end
          end
        end
      end
    end
  end
end
