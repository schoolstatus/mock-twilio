# frozen_string_literal: true

require 'faraday'

module Mock
  module Twilio
    module Middleware
      class Proxy < Faraday::Middleware
        def initialize(app)
          super(app)
        end

        def call(env)
          env.url.host = env.request.proxy.host
          env.url.port = env.request.proxy.port
          env.url.scheme = env.request.proxy.scheme
          env.request_headers.merge!({ 'Prefer' => 'code=429' }) if forced_error(env.request_body)
          super
        end

        def forced_error(request_body)
          return unless request_body && request_body["Body"]

          string = ::Rack::Utils.parse_nested_query(request_body)
          string["Body"].downcase.include?('error')
        end
      end
    end
  end
end

Faraday::Request.register_middleware(proxy: Mock::Twilio::Middleware::Proxy)
