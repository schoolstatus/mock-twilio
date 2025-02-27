# frozen_string_literal: true

module Mock
  module Twilio
    class WebhooksClient
      attr_accessor :adapter
      attr_reader :timeout, :last_request

      def initialize(timeout: nil)
        @timeout = timeout
        @adapter = Faraday.default_adapter
      end

      def _request(request)
        url = request.host.split(":").last.to_i.zero? ? (request.host + ":" + request.port.to_s) : request.host

        @connection = Faraday.new(url: url, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.request :url_encoded
          f.adapter @adapter
          f.headers = request.headers
          f.request(:authorization, :basic, request.auth[0], request.auth[1])

          f.options.open_timeout = request.timeout || @timeout
          f.options.timeout = request.timeout || @timeout
        end

        response = @connection.send(request.method.downcase.to_sym,
                                    request.url,
                                    request.method == "GET" ? request.params : request.data)

        if response.body && !response.body.empty?
          object = response.body
        elsif response.status == 400
          object = { message: "Bad request", code: 400 }.to_json
        end

        response
      end

      def request(host, port, method, url, params = {}, data = {}, headers = {}, auth = nil, timeout = nil)
        request = ::Twilio::Request.new(host, port, method, url, params, data, headers, auth, timeout)
        _request(request)
      end
    end
  end
end
