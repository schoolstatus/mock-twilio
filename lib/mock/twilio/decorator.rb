# frozen_string_literal: true

require_relative "schemas/api_2010"
require_relative "schemas/messaging_v1"
require_relative "schemas/customer_profiles_v1"
require_relative "schemas/end_users_v1"
require_relative "schemas/supporting_documents_v1"
require_relative "schemas/phone_numbers_v2"
require_relative "schemas/brands_registrations_a2p"
require_relative "schemas/trust_products_v1"

module Mock
  module Twilio
    class Decorator
      ENDPOINTS = {
        api_2010: Mock::Twilio::Schemas::Api2010,
        messaging_v1: Mock::Twilio::Schemas::MessagingV1,
        customer_profiles_v1: Mock::Twilio::Schemas::CustomerProfilesV1,
        end_users_v1: Mock::Twilio::Schemas::EndUsersV1,
        supporting_documents_v1: Mock::Twilio::Schemas::SupportingDocumentsV1,
        phone_numbers_v2: Mock::Twilio::Schemas::PhoneNumbersV2,
        brands_registrations_a2p: Mock::Twilio::Schemas::BrandsRegistrationsA2p,
        trust_products_v1: Mock::Twilio::Schemas::TrustProductsV1
      }

      class << self
        def call(body, request)
          body = JSON.parse(body)

          case body["status"]
          when 400..600
            return body
          end

          schema = url_from(body, request)
          # return body decorate if needed
          return ENDPOINTS[schema].for(body, request) if schema

          body
        end

        def url_from(body, request)
          url = request.url.split(request.host).last

          case url
          when %r{\/2010-04-01/Accounts/[A-Za-z0-9]+/}
            :api_2010
          when %r{\/v1\/Services\/\w{34}}
            :messaging_v1
          when %r{\/v1/CustomerProfiles}
            :customer_profiles_v1
          when %r{\/v1/EndUsers}
            :end_users_v1
          when %r{\/v1/SupportingDocuments}
            :supporting_documents_v1
          when %r{\/v2/PhoneNumbers}
            :phone_numbers_v2
          when %r{\/v1/a2p/BrandRegistrations}
            :brands_registrations_a2p
          when %r{\/v1/TrustProducts}
            :trust_products_v1
          end
        end
      end
    end
  end
end
