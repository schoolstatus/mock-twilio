# frozen_string_literal: true

require_relative "../decorators/customer_profiles_v1/customer_profile"
require_relative "../decorators/customer_profiles_v1/entity_assignments"
require_relative "../decorators/customer_profiles_v1/evaluations"
require_relative "../decorators/customer_profiles_v1/customer_profile_update"
require_relative "../decorators/customer_profiles_v1/channel_endpoint_assignments"

module Mock
  module Twilio
    module Schemas
      class CustomerProfilesV1
        class << self
          RESOURCES = {
            customer_profile: Mock::Twilio::Decorators::CustomerProfilesV1::CustomerProfile,
            entity_assigments: Mock::Twilio::Decorators::CustomerProfilesV1::EntityAssignments,
            evaluations: Mock::Twilio::Decorators::CustomerProfilesV1::Evaluations,
            customer_profile_update: Mock::Twilio::Decorators::CustomerProfilesV1::CustomerProfileUpdate,
            channel_endpoint_assignments: Mock::Twilio::Decorators::CustomerProfilesV1::ChannelEndpointAssignments,
          }

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{/v1/CustomerProfiles$}
              RESOURCES[:customer_profile].decorate(body, request)
            when %r{/v1/CustomerProfiles/[A-Za-z0-9]+/EntityAssignments}
              RESOURCES[:entity_assigments].decorate(body, request)
            when %r{/v1/CustomerProfiles/[A-Za-z0-9]+/Evaluations}
              RESOURCES[:evaluations].decorate(body, request)
            when %r{/v1/CustomerProfiles/[A-Za-z0-9]+/ChannelEndpointAssignments}
              if request.method.downcase == 'get'
                RESOURCES[:channel_endpoint_assignments].decorate(body, request)
              else
                body
              end
            when %r{/v1/CustomerProfiles/[A-Za-z0-0]+}
              RESOURCES[:customer_profile_update].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
