# frozen_string_literal: true

require_relative "../decorators/trust_products_v1/trust_products"
require_relative "../decorators/trust_products_v1/update"

module Mock
  module Twilio
    module Schemas
      class TrustProductsV1
        class << self
          RESOURCES = {
            trust_products: Mock::Twilio::Decorators::TrustProductsV1::TrustProducts,
            update: Mock::Twilio::Decorators::TrustProductsV1::Update
          }

          def for(body, request)
            url = request.url.split(request.host).last

            case url
            when %r{\/v1/TrustProducts$}
              RESOURCES[:trust_products].decorate(body, request)
            when %r{\/v1/TrustProducts/[A-Za-z0-0]+}
              RESOURCES[:update].decorate(body, request)
            end
          end
        end
      end
    end
  end
end
