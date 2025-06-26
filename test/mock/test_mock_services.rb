# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  include Mock::Twilio::Generator
  HOST = Mock::Twilio.host
  STATUS_CALLBACKS = "#{HOST}/api/v1/twilio_calls/participant_status_changes".freeze

  def test_mock_calls_service
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/participant_status_changes").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"ringing", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/participant_status_changes").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"completed", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    body = { "from" => "+18111111111", "to" => "+18222222222" }
    service = Mock::Twilio::Services::CallService.new("SIDTESTING", STATUS_CALLBACKS, body)

    response = service.call

    assert_equal true, response.success?
    assert_includes response.env.request_body, "completed"
  end

  def test_mock_conference_calls_service
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/participant_status_changes").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"ringing", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/participant_status_changes").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"completed", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "AnsweredBy"=>"unknown", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"ringing", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "StirStatus"=>"B", "StirVerstat"=>"TN-Validation-Passed-B", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(
        status: 200,
        body: <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <Response>
            <Dial>
              <Conference>Room 1234</Conference>
            </Dial>
          </Response>
        XML
        headers: { 'Content-Type' => 'application/xml' }
       )

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "AnsweredBy"=>"human", "ApiVersion"=>"2010-04-01", "CallDuration"=>"0", "CallSid"=>"SIDTESTING", "CallStatus"=>"completed", "CallbackSource"=>"call-progress-events", "Called"=>"+18222222222", "CalledCity"=>"TAMPA", "CalledCountry"=>"US", "CalledState"=>"FL", "CalledZip"=>"33605", "Caller"=>"+18111111111", "CallerCity"=>"no value", "CallerCountry"=>"US", "CallerState"=>"CA", "CallerZip"=>"no value", "Direction"=>"outbound-api", "Duration"=>"0", "From"=>"+18111111111", "FromCity"=>"no value", "FromCountry"=>"US", "FromState"=>"CA", "FromZip"=>"no value", "SequenceNumber"=>"2", "SipResponseCode"=>"487", "StirStatus"=>"B", "StirVerstat"=>"TN-Validation-Passed-B", "Timestamp"=>"2024-06-17 16:49:31 UTC", "To"=>"+18222222222", "ToCity"=>"TAMPA", "ToCountry"=>"US", "ToState"=>"FL", "ToZip"=>"33605"}).
      to_return(
        status: 200,
        body: <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <Response>
            <Dial>
              <Conference>Room 1234</Conference>
            </Dial>
          </Response>
        XML
        headers: { 'Content-Type' => 'application/xml' }
       )

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/conference_status_changes").
      with( body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "ConferenceSid"=>"CFfb256bfeb50bc8bf9abf7682852753e1", "FriendlyName"=>"Room 1234", "Reason"=>"Participant from mock twilio", "SequenceNumber"=>"6", "StatusCallbackEvent"=>"conference-end", "Timestamp"=>"2024-06-17 16:49:31 UTC"}).
      to_return(status: 200, body: "", headers: {})

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_calls/create_voicemail").
      with(body: {"AccountSid"=>"ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "CallSid"=>"SIDTESTING", "ErrorCode"=>"0", "RecordingChannels"=>"1", "RecordingDuration"=>"4", "RecordingSid"=>"RE576165e82a42b1cd79d8c6ac4872506f", "RecordingSource"=>"RecordVerb", "RecordingStartTime"=>"Wed, 25 Jun 2025 18:27:04 -0600", "RecordingStatus"=>"completed", "RecordingUrl"=>"https://cdn.pixabay.com/download/audio/2022/03/24/audio_4ff823c44c.mp3?filename=ding-101492.mp3"}).
      to_return(status: 200, body: "", headers: {})

    fixed_conf_sid = "CFfb256bfeb50bc8bf9abf7682852753e1"
    Mock::Twilio::Generator.define_method(:random_conference_sid) do
      fixed_conf_sid
    end

    fixed_rec_sid = "RE576165e82a42b1cd79d8c6ac4872506f"
    Mock::Twilio::Generator.define_method(:random_voicemail_sid) do
      fixed_rec_sid
    end

    twiml = "http://shunkan-ido-service/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8"
    body = { "from" => "+18111111111", "to" => "+18222222222" }
    service = Mock::Twilio::Services::ConferenceCallService.new("SIDTESTING", twiml, STATUS_CALLBACKS, body)

    response = service.call

    assert_equal true, response.success?
    assert_includes response.env.request_body, "completed"
  end
end
