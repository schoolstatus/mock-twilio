# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class ConferencesParticipants
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["account_sid"] = ::Twilio.account_sid if body["account_sid"]
              body["label"] = "Mock Customer" if body["label"]
              body["status"] = "complete" if body["status"]

              parse_call_sid(body, request) if body["call_sid"]
              parse_conference_sid(body, request) if body["conference_sid"]

              body
            end

            def parse_call_sid(body, request)
              uri = URI(request.url)
              call_sid = uri.path.split('/')[7].split('.').first
              body["call_sid"] = call_sid
            end

            def parse_conference_sid(body, request)
              uri = URI(request.url)
              conference_sid = uri.path.split('/')[5]
              body["conference_sid"] = conference_sid
            end
          end
        end
      end
    end
  end
end
