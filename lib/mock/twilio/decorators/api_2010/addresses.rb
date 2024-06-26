# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class Addresses
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]

              address_sid(body, request) if body["sid"]
              body["iso_country"] = "US" if body["iso_country"]
              body["city"] = request.data["City"] if body["city"]
              body["region"] = request.data["Region"] if body["region"]
              body["street"] = request.data["Street"] if body["street"]
              body["postal_code"] = request.data["PostalCode"] if body["postal_code"]
              body["friendly_name"] = request.data["FriendlyName"] if body["friendly_name"]

              body["emergency_enabled"] = false if body["emergency_enabled"]
              body["validated"] = true if body["validated"]
              body["verified"] = true if body["verified"]

              body
            end

            def address_sid(body, request)
              prefix = "AD"
              sid = prefix + SecureRandom.hex(16)
              body["sid"] = sid
            end
          end
        end
      end
    end
  end
end
