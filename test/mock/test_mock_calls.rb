# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  HOST = Mock::Twilio.host
  WEBHOOK = "#{HOST}/api/v1/twilio_calls/voice_responses".freeze
  STATUS_CALLBACKS = "#{HOST}/api/v1/twilio_calls/participant_status_changes".freeze

  def test_mock_client_calls
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"string",
                             "date_updated"=>"string",
                             "parent_call_sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "to"=>"string",
                             "to_formatted"=>"string",
                             "from"=>"string",
                             "from_formatted"=>"string",
                             "phone_number_sid"=>"stringstringstringstringstringstri",
                             "status"=>"queued",
                             "start_time"=>"string",
                             "end_time"=>"string",
                             "duration"=>"string",
                             "price"=>"string",
                             "price_unit"=>"string",
                             "direction"=>"string",
                             "answered_by"=>"string",
                             "api_version"=>"string",
                             "forwarded_from"=>"string",
                             "group_sid"=>"stringstringstringstringstringstri",
                             "caller_name"=>"string",
                             "queue_time"=>"string",
                             "trunk_sid"=>"stringstringstringstringstringstri",
                             "uri"=>"string",
                             "subresource_uris"=>{}}

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Calls.json").
      with(body: {"From"=>"+18111111111", "MachineDetection"=>"Enable", "StatusCallback"=>"http://shunkan-ido-service/api/v1/twilio_calls/participant_status_changes", "StatusCallbackEvent"=>"completed", "StatusCallbackMethod"=>"POST", "Timeout"=>"30", "To"=>"+18222222222", "Url"=>"http://shunkan-ido-service/api/v1/twilio_calls/voice_responses?conference_uuid=c843e10f-142a-4c31-a1ca-dcf67233c7c8"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    conference_uuid = "c843e10f-142a-4c31-a1ca-dcf67233c7c8"
    twilio_number = "+18111111111"
    caller_number = "+18222222222"
    payload = {
      url: "#{WEBHOOK}?conference_uuid=#{conference_uuid}",
      from: twilio_number,
      to: caller_number,
      status_callback: STATUS_CALLBACKS,
      status_callback_event: %w[initiated ringing answered completed],
      status_callback_method: "POST",
      timeout: 30,
      machine_detection: "Enable" }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.calls.create(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert "CA", response.sid[0,2]
  end
end
