# frozen_string_literal: true

require_relative "../decorators/trust_products_v1/trust_products"
require_relative "../decorators/trust_products_v1/update"
require_relative "../decorators/trust_products_v1/evaluations"
require_relative "../decorators/trust_products_v1/entity_assignments"

module Mock
  module Twilio
    module Schemas
      class TrustProductsV1
        class << self
          RESOURCES = {
            trust_products: Mock::Twilio::Decorators::TrustProductsV1::TrustProducts,
            update: Mock::Twilio::Decorators::TrustProductsV1::Update,
            evaluations: Mock::Twilio::Decorators::TrustProductsV1::Evaluations,
            entity_assignments: Mock::Twilio::Decorators::TrustProductsV1::EntityAssignments,
          }

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/v1/TrustProducts$}
              RESOURCES[:trust_products].decorate(body, request)
            when %r{\/v1/TrustProducts/\w{34}$}
              RESOURCES[:update].decorate(body, request)
            when %r{\/v1\/TrustProducts\/\w{34}\/Evaluations$}
              RESOURCES[:evaluations].decorate(body, request)
            when %r{\/v1\/TrustProducts\/\w{34}\/EntityAssignments$}
              RESOURCES[:entity_assignments].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
