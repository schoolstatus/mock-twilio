# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module TrustProductsV1
        class Evaluations
          class << self
            def decorate(body, request)
              parse_trust_product_sid(body, request) if body["trust_product_sid"]
              evaluation_sid(body) if body["sid"]

              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["account_sid"] = ::Twilio.account_sid
              body["policy_sid"] = request.data["PolicySid"] if body["policy_sid"]
              body["status"] = "compliant" if body["status"]

              body
            end

            def evaluation_sid(body)
              prefix = "EL"
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
