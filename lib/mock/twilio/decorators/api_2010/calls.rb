# frozen_string_literal: true

module Mock
  module Twilio
    module Decorators
      module Api2010
        class Calls
          class << self
            def decorate(body, request)
              body["date_updated"] = Time.current.rfc2822 if body["date_updated"]
              body["date_sent"] = Time.current.rfc2822 if body["date_sent"]
              body["date_created"] = Time.current.rfc2822 if body["date_created"]
              body["start_time"] = Time.current.rfc2822 if body["start_time"]
              body["end_time"] = Time.current.rfc2822 if body["end_time"]

              call_sid(body, request) if body["sid"]
              phone_number_sid(body, request) if body["phone_number_sid"]
              body["direction"] = "outbound-api" if body["direction"]
              body["api_version"] = "2010-04-01" if body["api_version"]
              body["to"] = request.data['To'] if body["to"]
              body["from"] = request.data['From'] if body["from"]

              body
            end

            def call_sid(body, request)
              prefix = "CA"
              sid = prefix + SecureRandom.hex(16)
              scheduler = Rufus::Scheduler.new
              scheduler.in '2s' do
                conference_uuid = request.data["Url"].split("conference_uuid=").last
                response = Mock::Twilio::Webhooks::CallStatusUpdates.trigger(sid, conference_uuid)

                conference_response = if response.status == 200
                                        twiMl_xml = Nokogiri::XML response.body
                                        friendly_name = twiMl_xml.at_xpath('//Dial').at_xpath('//Conference').children.text
                                        Mock::Twilio::Webhooks::Conferences.trigger(friendly_name)
                                      end

                Mock::Twilio::Webhooks::Calls.trigger(sid) if conference_response.status == 200
              end
              body["sid"] = sid
            end

            def phone_number_sid(body, request)
              prefix = "PN"
              sid = prefix + SecureRandom.hex(16)
              body["phone_number_sid"] = sid
            end
          end
        end
      end
    end
  end
end
