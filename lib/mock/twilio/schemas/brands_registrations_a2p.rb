# frozen_string_literal: true

module Mock
  module Twilio
    module Schemas
      class BrandsRegistrationsA2p
        @@scheduler = Rufus::Scheduler.new

        class << self
          def for(body, request)
            body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
            body["date_created"] = Time.current.rfc2822 if body["date_created"]

            brand_sid(body) if body["sid"]
            body["account_sid"] = ::Twilio.account_sid  if body["account_sid"]
            body["customer_profile_bundle_sid"] = request.data["CustomerProfileBundleSid"] if body["customer_profile_bundle_sid"]
            body["a2p_profile_bundle_sid"] = request.data["A2PProfileBundleSid"] if body["a2p_profile_bundle_sid"]
            body["brand_type"] = request.data["BrandType"] if body["brand_type"]
            body["account_sid"] = ::Twilio.account_sid  if body["account_sid"]

            body["status"] = "PENDING" if body["status"]
            body["brand_score"] = 100 if body["brand_score"]
            body["identity_status"] = "SELF_DECLARED" if body["identity_status"]
            body["tcr_id"] = "BXXXXXX" if body["tcr_id"]
            body["tax_exempt_status"] = "501c3" if body["tax_exempt_status"]

            body["errors"] = nil if body["errors"]
            body["failure_reason"] = nil if body["failure_reason"]
            body["links"] = { "brand_vettings": "http://example.com", "brand_registration_otps": "http://example.com" } if body["links"]

            body
          end

          def brand_sid(body)
            prefix = "BN"
            sid = prefix + SecureRandom.hex(16)
            @@scheduler.in '2s' do
              response = Mock::Twilio::Webhooks::Brands.trigger(sid, "unverified")
              response = if response.status == 200
                           Mock::Twilio::Webhooks::Brands.trigger(sid, "verified")
                         end
            end
            body["sid"] = sid
          end
        end
      end
    end
  end
end
