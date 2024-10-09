# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module CustomerProfilesV1
        class ChannelEndpointAssignments
          class << self
            include Mock::Twilio::Generator

            def decorate(body, request)
              decorate_results(body, request) unless body["results"].nil?
              decorate_meta(body, request) unless body["meta"].nil?

              body
            end

            private

            def decorate_meta(body, request)
              customer_profile_sid = parse_customer_profile_sid(request)

              body["meta"].tap do |meta|
                page_size = body["results"].length
                meta["page_size"] = page_size
                meta["first_page_url"] = "https://trusthub.twilio.com/v1/CustomerProfiles#{customer_profile_sid}/ChannelEndpointAssignments?PageSize=#{page_size}&Page=0"
                meta["previous_page_url"] = nil
                meta["next_page_url"] = nil
                meta["url"] = "https://trusthub.twilio.com/v1/CustomerProfiles#{customer_profile_sid}/ChannelEndpointAssignments?PageSize=#{page_size}&Page=0"
                meta["key"] = "results"
              end
            end

            def decorate_results(body, request)
              customer_profile_sid = parse_customer_profile_sid(request)

              body["results"].each do |result|
                result["customer_profile_sid"] = customer_profile_sid if result["customer_profile_sid"]
                result["sid"] = random_assignment_sid if result["sid"]
                result["channel_endpoint_sid"] = random_phone_number_sid if result["channel_endpoint_sid"]
                result["url"] = "https://trusthub.twilio.com/v1/CustomerProfiles/#{customer_profile_sid}/ChannelEndpointAssignments/#{result["sid"]}"
                result["channel_endpoint_type"] = "phone-number" if result["channel_endpoint_type"]
                result["account_sid"] = ::Twilio.account_sid
                result["date_created"] = Time.current.rfc2822 if result["date_created"]
              end
            end

            def parse_customer_profile_sid(request)
              uri = URI(request.url)
              uri.path.split('/')[3]
            end
          end
        end
      end
    end
  end
end
