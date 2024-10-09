# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class IncomingPhoneNumbers
          class << self
            include Mock::Twilio::Generator

            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]

              body["sid"] = random_phone_number_sid if body["sid"]
              body["identity_sid"] = random_identity_sid if body["identity_sid"]
              body["emergency_address_sid"] = random_address_sid if body["emergency_address_sid"]
              body["address_sid"] = random_address_sid if body["address_sid"]
              body["bundle_sid"] = random_bundle_sid if body["bundle_sid"]

              body
            end
          end
        end
      end
    end
  end
end
