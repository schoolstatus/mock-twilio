# frozen_string_literal: true

require_relative "../decorators/trust_products_v1/trust_products"
require_relative "../decorators/trust_products_v1/update"
require_relative "../decorators/trust_products_v1/evaluations"
require_relative "../decorators/trust_products_v1/entity_assignments"
require_relative "../decorators/trust_products_v1/channel_endpoint_assignments"

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
            channel_endpoint_assignments: Mock::Twilio::Decorators::TrustProductsV1::ChannelEndpointAssignments,
          }

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{/v1/TrustProducts$}
              RESOURCES[:trust_products].decorate(body, request)
            when %r{/v1/TrustProducts/\w{34}$}
              RESOURCES[:update].decorate(body, request)
            when %r{/v1/TrustProducts/\w{34}/Evaluations$}
              RESOURCES[:evaluations].decorate(body, request)
            when %r{/v1/TrustProducts/\w{34}/EntityAssignments$}
              RESOURCES[:entity_assignments].decorate(body, request)
            when %r{/v1/TrustProducts/[A-Za-z0-9]+/ChannelEndpointAssignments}
              if request.method.downcase == 'get'
                RESOURCES[:channel_endpoint_assignments].decorate(body, request)
              else
                body
              end
            end
          end
        end
      end
    end
  end
end
