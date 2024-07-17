# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module TrustProductsV1
        class Update
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]

              trust_product_sid(body) if body["sid"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]

              body["friendly_name"] = request.data["FriendlyName"] if body["friendly_name"]
              body["email"] = request.data["Email"] if body["email:"]
              body["policy_sid"] = request.data["PolicySid"] if body["policy_sid"]
              body["status"] = request.data["Status"] if body["status"]
              body["valid_until"] = nil if body["valid_until"]

              body
            end

            def trust_product_sid(body)
              prefix = "BU"
              sid = prefix + SecureRandom.hex(16)
              body["sid"] = sid
            end
          end
        end
      end
    end
  end
end
