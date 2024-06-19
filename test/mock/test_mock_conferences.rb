# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  HOST = Mock::Twilio.host
  CALLBACK_URL = "#{HOST}/api/v1/twilio_calls/participant_status_changes".freeze

  def test_mock_client_conferences_create
    mock_server_response = { "account_sid"=>"stringstringstringstringstringstri",
                             "call_sid"=>"stringstringstringstringstringstri",
                             "label"=>"string",
                             "call_sid_to_coach"=>"stringstringstringstringstringstri",
                             "coaching"=>true,
                             "conference_sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"string",
                             "date_updated"=>"string",
                             "end_conference_on_exit"=>true,
                             "muted"=>true,
                             "hold"=>true,
                             "start_conference_on_enter"=>true,
                             "status"=>"queued",
                             "queue_time"=>"string",
                             "uri"=>"string"}

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Conferences/CF5bb996a0f3deaa0c6bb1b17ffd338c87/Participants.json").
      with(
        body: {"Beep"=>"onEnter", "EarlyMedia"=>"true", "From"=>"+18111111111", "Record"=>"true", "StatusCallback"=>"http://shunkan-ido-service/api/v1/twilio_calls/participant_status_changes", "StatusCallbackEvent"=>"completed", "Timeout"=>"30", "To"=>"+18222222222"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/6.7.1 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})


    conference_sid = "CF5bb996a0f3deaa0c6bb1b17ffd338c87"
    from = "+18111111111"
    to = "+18222222222"
    payload = {
      early_media: true,
      beep: "onEnter",
      status_callback: CALLBACK_URL,
      status_callback_event: %w[initiated ringing answered completed],
      record: true,
      from: from,
      to: to,
      timeout: 30 }


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.conferences(conference_sid).participants.create(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert "CA", response.call_sid[0,2]
    assert "CF", response.conference_sid[0,2]
    assert "initiated", response.status
  end

  def test_mock_client_conferences_update
    mock_server_response = {"account_sid"=>"stringstringstringstringstringstri",
                            "call_sid"=>"stringstringstringstringstringstri",
                            "label"=>"string",
                            "call_sid_to_coach"=>"stringstringstringstringstringstri",
                            "coaching"=>true,
                            "conference_sid"=>"stringstringstringstringstringstri",
                            "date_created"=>"string",
                            "date_updated"=>"string",
                            "end_conference_on_exit"=>true,
                            "muted"=>true,
                            "hold"=>true,
                            "start_conference_on_enter"=>true,
                            "status"=>"queued",
                            "queue_time"=>"string",
                            "uri"=>"string" }

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Conferences/CF5bb996a0f3deaa0c6bb1b17ffd338c87/Participants/CA06f6360ddeb85932241e0be5407d4f7d.json").
      with(
        body: {"AnnounceMethod"=>"GET", "AnnounceUrl"=>"http://shunkan-ido-service/api/v1/twilio_calls/123abc/call_welcome_message"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/6.7.1 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})

    payload = {
      announce_method: "GET",
      announce_url: "#{HOST}/api/v1/twilio_calls/123abc/call_welcome_message"
    }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.conferences("CF5bb996a0f3deaa0c6bb1b17ffd338c87").participants("CA06f6360ddeb85932241e0be5407d4f7d").update(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert "CA", response.call_sid[0,2]
    assert "CF", response.conference_sid[0,2]
    assert "complete", response.status
  end
end
