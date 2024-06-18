# frozen_string_literal: true

require_relative "schemas/api_2010"
require_relative "schemas/messaging_v1"

module Mock
  module Twilio
    class Decorator
      ENDPOINTS = {
        api_2010: Mock::Twilio::Schemas::Api2010,
        messaging_v1: Mock::Twilio::Schemas::MessagingV1,
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
          when %r{\/v1/Services/[A-Za-z0-9]+/}
            :messaging_v1
          end
        end
      end
    end
  end
end
