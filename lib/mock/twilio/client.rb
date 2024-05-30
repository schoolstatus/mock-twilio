# frozen_string_literal: true

module Mock
  module Twilio
    # mock_client = Mock::Twilio::Client.new
    # client = Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    # client.messages.create(to: "+593978613041", body: "RB This is the ship that made the Kesssssel Run in fourteen parsecs?", from: "+13212855389")
    class Client
      attr_accessor :adapter
      attr_reader :timeout, :last_response, :last_request

      def initialize(proxy_prot = nil, proxy_addr = nil, proxy_port = nil, timeout: nil)
        @proxy_prot = proxy_prot || 'http'
        @proxy_addr = proxy_addr || 'twilio_mock_server'
        @proxy_port = proxy_port || '4010'
        @timeout = timeout
        @adapter = Faraday.default_adapter
      end

      def _request(request)
        @connection = Faraday.new(url: request.host + ":" + request.port.to_s, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.request :url_encoded
          f.adapter @adapter
          f.headers = request.headers
          f.request(:authorization, :basic, request.auth[0], request.auth[1])
          if @proxy_addr
            f.proxy = "#{@proxy_prot}://#{@proxy_addr}:#{@proxy_port}"
          end

          f.use Mock::Twilio::Middleware::Proxy

          f.options.open_timeout = request.timeout || @timeout
          f.options.timeout = request.timeout || @timeout
        end

        @last_request = request
        @last_response = nil
        response = @connection.send(request.method.downcase.to_sym,
                                    request.url,
                                    request.method == "GET" ? request.params : request.data)

        if response.body && !response.body.empty?
          object = response.body
        elsif response.status == 400
          object = { message: "Bad request", code: 400 }.to_json
        end

        twilio_response = Mock::Twilio::Response.new(response.status, object, request, headers: response.headers)
        @last_response = twilio_response

        twilio_response
      end

      def request(host, port, method, url, params = {}, data = {}, headers = {}, auth = nil, timeout = nil)
        request = ::Twilio::Request.new(host, port, method, url, params, data, headers, auth, timeout)
        _request(request)
      end
    end
  end
end
