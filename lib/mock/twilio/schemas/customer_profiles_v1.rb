# frozen_string_literal: true

require_relative "../decorators/customer_profiles_v1/customer_profile"
require_relative "../decorators/customer_profiles_v1/entity_assignments"
require_relative "../decorators/customer_profiles_v1/evaluations"

module Mock
  module Twilio
    module Schemas
      class CustomerProfilesV1
        class << self
          RESOURCES = {
            customer_profile: Mock::Twilio::Decorators::CustomerProfilesV1::CustomerProfile,
            entity_assigments: Mock::Twilio::Decorators::CustomerProfilesV1::EntityAssignments,
            evaluations: Mock::Twilio::Decorators::CustomerProfilesV1::Evaluations
          }

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/v1/CustomerProfiles$}
              RESOURCES[:customer_profile].decorate(body, request)
            when %r{\/v1/CustomerProfiles/[A-Za-z0-9]+/EntityAssignments}
              RESOURCES[:entity_assigments].decorate(body, request)
            when %r{\/v1/CustomerProfiles/[A-Za-z0-9]+/Evaluations}
              RESOURCES[:evaluations].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
