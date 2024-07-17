# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module TrustProductsV1
        class EntityAssignments
          class << self
            def decorate(body, request)
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              entity_sid(body, request) if body["sid"]
              body["account_sid"] = ::Twilio.account_sid
              body["object_sid"] = request.data["ObjectSid"]
              parse_trust_product_sid(body, request) if body["trust_product_sid"]

              body
            end

            def entity_sid(body, request)
              prefix = "BV"
              sid = prefix + SecureRandom.hex(16)
              body["sid"] = sid
            end

            def parse_trust_product_sid(body, request)
              uri = URI(request.url)
              trust_product_sid = uri.path.split('/')[3].split('.').first
              body["trust_product_sid"] = trust_product_sid
            end
          end
        end
      end
    end
  end
end
