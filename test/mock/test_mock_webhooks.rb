# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_webhook_message_trigger
    stub_request(:post, "http://test.com/callback_url").
      with(body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"}).
      to_return(status: 200, body: "", headers: {})

    response = Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING", "http://test.com/callback_url")

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "R/t8sPRgN+rlhwL3LEQFwLJl7Jk=", response.env.request_headers['X-twilio-signature']
    assert_equal "MessageSid=SIDTESTING&MessageStatus=delivered", response.env.request_body
  end

  def test_mock_webhook_message_trigger_error_json
    service_response = {"error"=>{"code"=>50001,
                                  "message"=>"There was an error related with the Twilio API",
                                  "detail"=>"Invalid Twilio Token, verify the signature"}}

    stub_request(:post, "http://test.com/callback_url").
      with(body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"}).
      to_return(status: 500, body: service_response.to_json, headers: { "Content-Type" => "application/json"} )


    assert_raises(Mock::Twilio::Webhooks::RestError) { Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING", "http://test.com/callback_url") }
  end

  def test_mock_webhook_message_trigger_error_html
    service_response ="<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n </head> \n </body>\n</html>\n"

    stub_request(:post, "http://test.com/callback_url").
      with(body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"}).
      to_return(status: 500, body: service_response, headers: { "Content-Type" => "text/html; charset=UTF-8"} )


    assert_raises(Mock::Twilio::Webhooks::RestError) { Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING", "http://test.com/callback_url") }
  end

  def test_mock_webhook_calls_trigger
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/participant_status_changes").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"ringing", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    status_callback = "http://shunkan-ido-service/api/v1/twilio_calls/participant_status_changes"
    body = { "from" => "+18111111111", "to" => "+18222222222" }
    response = Mock::Twilio::Webhooks::Calls.trigger("SIDTESTING", status_callback, "ringing", body)

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "SQKQ+yNooNS5SNeTWzety1b3oRc=", response.env.request_headers['X-twilio-signature']
    assert response.env.request_body.include?("ringing")
  end

  def test_mock_webhook_calls_updates_trigger
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "AnsweredBy"=>"unknown", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"ringing", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "StirStatus"=>"B", "StirVerstat"=>"TN-Validation-Passed-B", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    twiml = "http://shunkan-ido-service/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8"
    body = { "from" => "+18111111111", "to" => "+18222222222" }
    response = Mock::Twilio::Webhooks::Twiml.trigger("SIDTESTING", twiml, "unknown", "ringing", body)

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "R+p1ei+IUFBtoxlPzz47O9NrH2Q=", response.env.request_headers['X-twilio-signature']
  end

  def test_mock_webhook_customer_profile_trigger
    stub_request(:post, "http://shunkan-ido-service:3000/webhooks/twilio/customer_profiles_compliance").
      with(body: {"BundleSid"=>"SIDTESTING", "Status"=>"in-review"}).
      to_return(status: 200, body: "", headers: {})

    response = Mock::Twilio::Webhooks::CustomerProfiles.trigger("SIDTESTING", "in-review")

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "3/Xbee9zCe2IfVU8N6olgb3VBXg=", response.env.request_headers['X-twilio-signature']
  end

  def test_mock_webhook_message_inbound_trigger
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_requests/inbound").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "AddOns"=>"{\"status\":\"successful\",\"message\":null,\"code\":null,\"results\":{}}", "ApiVersion"=>"2010-04-01", "Body"=>"Inbound::Message mock reply", "From"=>"+1987654321", "FromCity"=>"SILVERDALE", "FromCountry"=>"US", "FromState"=>"WA", "FromZip"=>"98315", "MessageSid"=>"SIDTESTING", "MessagingServiceSid"=>"MFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFff", "NumMedia"=>"0", "NumSegments"=>"1", "SmsMessageSid"=>"SIDTESTING", "SmsSid"=>"SIDTESTING", "SmsStatus"=>"received", "To"=>"+1123456789", "ToCity"=>"SARDIS", "ToCountry"=>"US", "ToState"=>"MS", "ToZip"=>"38666"}).
      to_return(status: 200, body: "", headers: {})

    request_data = { "To" => "+1123456789", "From" => "+1987654321", "MessagingServiceSid" => "MFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFff" }
    response = Mock::Twilio::Webhooks::InboundMessages.trigger("SIDTESTING", request_data )

    expected_body = "AccountSid=ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF&AddOns=%7B%22status%22%3A%22successful%22%2C%22message%22%3Anull%2C%22code%22%3Anull%2C%22results%22%3A%7B%7D%7D&ApiVersion=2010-04-01&Body=Inbound%3A%3AMessage+mock+reply&From=%2B1987654321&FromCity=SILVERDALE&FromCountry=US&FromState=WA&FromZip=98315&MessageSid=SIDTESTING&MessagingServiceSid=MFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFff&NumMedia=0&NumSegments=1&SmsMessageSid=SIDTESTING&SmsSid=SIDTESTING&SmsStatus=received&To=%2B1123456789&ToCity=SARDIS&ToCountry=US&ToState=MS&ToZip=38666"

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "Ivv/g+EGMwuhN8+3PpwlsS+A1eg=", response.env.request_headers['X-twilio-signature']
    assert_equal expected_body, response.env.request_body
  end

  def test_mock_webhook_message_status_url_trigger
    Mock::Twilio.configure do |config|
      config.webhook_message_status_url = "http://shunkan_ido/api/v1/twilio_requests/webhook_message_updates"
    end

    stub_request(:post, "http://shunkan_ido/api/v1/twilio_requests/webhook_message_updates").
      with(body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"}).
      to_return(status: 200, body: "", headers: {})

    response = Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING", nil)

    assert_equal "forwarded_host.app", response.env.request_headers['Host']
    assert_equal "http", response.env.request_headers['X-forwarded-proto']
    assert_equal "fSX0swfxH1zw3AxBsY8hFGSlQR4=", response.env.request_headers['X-twilio-signature']
    assert_equal "MessageSid=SIDTESTING&MessageStatus=delivered", response.env.request_body

    Mock::Twilio.configure do |config|
      config.webhook_message_status_url = nil
    end
  end

  def test_mock_webhook_message_urls_trigger_error
    assert_raises("There is not webhook_message_status_url or status_callback") { Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING", nil) }
  end
end
