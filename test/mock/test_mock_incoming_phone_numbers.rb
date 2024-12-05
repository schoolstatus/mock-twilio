# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  include Mock::Twilio::Generator

  def test_mock_incoming_phone_numbers_update
    mock_server_response = {
      "account_sid" => "stringstringstringstringstringstri",
      "address_sid" => "stringstringstringstringstringstri",
      "address_requirements" => "string",
      "api_version" => "string",
      "beta" => true,
      "capabilities" => {
        "mms" => true,
        "sms" => true,
        "voice" => true,
        "fax" => true
      },
      "date_created" => "string",
      "date_updated" => "string",
      "friendly_name" => "string",
      "identity_sid" => "stringstringstringstringstringstri",
      "phone_number" => "string",
      "origin" => "string",
      "sid" => "stringstringstringstringstringstri",
      "sms_application_sid" => "stringstringstringstringstringstri",
      "sms_fallback_method" => "GET",
      "sms_fallback_url" => "http://example.com",
      "sms_method" => "GET",
      "sms_url" => "http://example.com",
      "status_callback" => "http://example.com",
      "status_callback_method" => "GET",
      "trunk_sid" => "stringstringstringstringstringstri",
      "uri" => "string",
      "voice_receive_mode" => "string",
      "voice_application_sid" => "stringstringstringstringstringstri",
      "voice_caller_id_lookup" => true,
      "voice_fallback_method" => "GET",
      "voice_fallback_url" => "http://example.com",
      "voice_method" => "GET",
      "voice_url" => "http://example.com",
      "emergency_status" => "string",
      "emergency_address_sid" => "stringstringstringstringstringstri",
      "emergency_address_status" => "string",
      "bundle_sid" => "stringstringstringstringstringstri",
      "status" => "string"
    }

    app_sid = random_twiml_app_sid
    phone_number_sid = random_phone_number_sid
    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/#{::Twilio.account_sid}/IncomingPhoneNumbers/#{phone_number_sid}.json").
      with(body: {"VoiceApplicationSid" => app_sid, "SmsApplicationSid" => app_sid}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.incoming_phone_numbers(phone_number_sid).update(sms_application_sid: app_sid, voice_application_sid: app_sid)

    assert_equal Time, response.date_updated.class
    assert_equal Time, response.date_created.class
    assert_equal ::Twilio.account_sid, response.account_sid
    assert response.sid.match(%r{PN[0-9a-zA-Z]{32}})
    assert response.identity_sid.match(%r{RI[0-9a-zA-Z]{32}})
    assert response.emergency_address_sid.match(%r{AD[0-9a-zA-Z]{32}})
    assert response.address_sid.match(%r{AD[0-9a-zA-Z]{32}})
    assert response.bundle_sid.match(%r{BU[0-9a-zA-Z]{32}})
  end

  def test_mock_incoming_phone_numbers_create
    mock_server_response = {
      "account_sid" => "stringstringstringstringstringstri",
      "address_sid" => "stringstringstringstringstringstri",
      "address_requirements" => "string",
      "api_version" => "string",
      "beta" => true,
      "capabilities" => {
        "mms" => true,
        "sms" => true,
        "voice" => true,
        "fax" => true
      },
      "date_created" => "string",
      "date_updated" => "string",
      "friendly_name" => "string",
      "identity_sid" => "stringstringstringstringstringstri",
      "phone_number" => "string",
      "origin" => "string",
      "sid" => "stringstringstringstringstringstri",
      "sms_application_sid" => "stringstringstringstringstringstri",
      "sms_fallback_method" => "GET",
      "sms_fallback_url" => "http://example.com",
      "sms_method" => "GET",
      "sms_url" => "http://example.com",
      "status_callback" => "http://example.com",
      "status_callback_method" => "GET",
      "trunk_sid" => "stringstringstringstringstringstri",
      "uri" => "string",
      "voice_receive_mode" => "string",
      "voice_application_sid" => "stringstringstringstringstringstri",
      "voice_caller_id_lookup" => true,
      "voice_fallback_method" => "GET",
      "voice_fallback_url" => "http://example.com",
      "voice_method" => "GET",
      "voice_url" => "http://example.com",
      "emergency_status" => "string",
      "emergency_address_sid" => "stringstringstringstringstringstri",
      "emergency_address_status" => "string",
      "bundle_sid" => "stringstringstringstringstringstri",
      "status" => "string"
    }

    app_sid = random_twiml_app_sid
    phone_number_sid = random_phone_number_sid
    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/#{::Twilio.account_sid}/IncomingPhoneNumbers.json").
      with(body: {"PhoneNumber" => "+14155552344"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.incoming_phone_numbers.create(phone_number: '+14155552344')

    assert_equal Time, response.date_updated.class
    assert_equal Time, response.date_created.class
    assert_equal ::Twilio.account_sid, response.account_sid
    assert response.sid.match(%r{PN[0-9a-zA-Z]{32}})
    assert response.identity_sid.match(%r{RI[0-9a-zA-Z]{32}})
    assert response.emergency_address_sid.match(%r{AD[0-9a-zA-Z]{32}})
    assert response.address_sid.match(%r{AD[0-9a-zA-Z]{32}})
    assert response.bundle_sid.match(%r{BU[0-9a-zA-Z]{32}})
  end
end
