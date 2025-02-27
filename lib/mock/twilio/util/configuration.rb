# frozen_string_literal: true

module Mock
  module Twilio
    module Util
      class Configuration
        attr_accessor :host, :forwarded_host, :port, :proto, :webhook_message_status_url

        def host=(value)
          @host = value
        end

        def forwarded_host=(value)
          @forwarded_host = value
        end

        def port=(value)
          @port = value
        end

        def proto=(value)
          @proto = value
        end

        def webhook_message_status_url=(value)
          @webhook_message_status_url = value
        end
      end
    end
  end
end
