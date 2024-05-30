# frozen_string_literal: true

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
          schema = url_from(body, request)
          # return body decorataor if needed
          return ENDPOINTS[schema].decorate(body) if schema

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
