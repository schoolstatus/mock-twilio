# frozen_string_literal: true

module Mock
  module Twilio
    module Schemas
      class SupportingDocumentsV1
        class << self
          def for(body, request)
            body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
            body["date_created"] = Time.current.rfc2822 if body["date_created"]
            body["account_sid"] = ::Twilio.account_sid if body["account_sid"]

            support_document_sid(body, request) if body["sid"]
            body["friendly_name"] = request.data["FriendlyName"] if body["friendly_name"]
            body["status"] = "approved" if body["status"]
            body["type"] = request.data["Type"] if body["type"]

            body
          end

          def support_document_sid(body, request)
            prefix = "RD"
            sid = prefix + SecureRandom.hex(16)
            body["sid"] = sid
          end
        end
      end
    end
  end
end
