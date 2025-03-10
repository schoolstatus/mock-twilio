# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module CustomerProfilesV1
        class CustomerProfileUpdate
         @@scheduler = Rufus::Scheduler.new

          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]

              parse_customer_profile_sid(body, request) if body["sid"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]
              # Usually from pending-review to in-review
              body["status"] = request.data["Status"] if body["status"]

              body
            end

            def parse_customer_profile_sid(body, request)
              uri = URI(request.url)
              customer_profile_sid = uri.path.split('/')[3].split('.').first
              @@scheduler.in '2s' do
                begin
                  response = Mock::Twilio::Webhooks::CustomerProfiles.trigger(customer_profile_sid, "in-review")

                  if response.status == 200
                    Mock::Twilio::Webhooks::CustomerProfiles.trigger(customer_profile_sid, "twilio-approved")
                  end
                rescue => e
                  puts e
                end
              end
              body["sid"] = customer_profile_sid
            end
          end
        end
      end
    end
  end
end
