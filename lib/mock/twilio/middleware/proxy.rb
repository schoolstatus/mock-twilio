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
          super
        end
      end
    end
  end
end

Faraday::Request.register_middleware(proxy: Mock::Twilio::Middleware::Proxy)
