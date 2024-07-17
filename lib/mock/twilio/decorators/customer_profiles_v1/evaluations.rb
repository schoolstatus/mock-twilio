# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module CustomerProfilesV1
        class Evaluations
          class << self
            def decorate(body, request)
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              parse_customer_profile_sid(body, request) if body["customer_profile_sid"]
              evaluation_sid(body, request) if body["sid"]
              body["account_sid"] = ::Twilio.account_sid
              body["policy_sid"] = request.data["PolicySid"] if body["policy_sid"]
              body["status"] = "compliant" if body["status"]

              body
            end

            def evaluation_sid(body, request)
              prefix = "EL"
              sid = prefix + SecureRandom.hex(16)
              scheduler = Rufus::Scheduler.new
              #scheduler.in '2s' do
                #Mock::Twilio::Webhooks::CustomerProfiles.trigger(body['customer_profile_sid'], "twilio-approved")
              #end
              body["sid"] = sid
            end

            def parse_customer_profile_sid(body, request)
              uri = URI(request.url)
              customer_profile_sid = uri.path.split('/')[3].split('.').first
              body["customer_profile_sid"] = customer_profile_sid
            end
          end
        end
      end
    end
  end
end
