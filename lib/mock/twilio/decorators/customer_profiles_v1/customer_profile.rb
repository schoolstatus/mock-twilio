# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module CustomerProfilesV1
        class CustomerProfile
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              customer_profile_sid(body, request) if body["sid"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]
              body["friendly_name"] = request.data["FriendlyName"] if body["friendly_name"]
              body["email"] = request.data["Email"] if body["email"]
              body["policy_sid"] = request.data["PolicySid"] if body["policy_sid"]
              body["status_callback"] = request.data["StatusCallback"] if body["status_callback"]
              body["status"] = "in-review" if body["status"]

              body
            end

            def customer_profile_sid(body, request)
              prefix = "BU"
              sid = prefix + SecureRandom.hex(16)
              scheduler = Rufus::Scheduler.new
              scheduler.in '2s' do
                Mock::Twilio::Webhooks::CustomerProfiles.trigger(sid, request.data["StatusCallback"])
              end
            end
          end
        end
      end
    end
  end
end
