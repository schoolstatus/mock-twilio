# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_message_sms
    mock_server_response = { "body"=>"string",
                              "num_segments"=>"string",
                              "direction"=>"inbound",
                              "from"=>"string",
                              "to"=>"string",
                              "date_updated"=>"string",
                              "price"=>"string",
                              "error_message"=>"string",
                              "uri"=>"string",
                              "account_sid"=>"stringstringstringstringstringstri",
                              "num_media"=>"string",
                              "status"=>"queued",
                              "messaging_service_sid"=>"stringstringstringstringstringstri",
                              "sid"=>"stringstringstringstringstringstri",
                              "date_sent"=>"string",
                              "date_created"=>"string",
                              "error_code"=>0,
                              "price_unit"=>"string",
                              "api_version"=>"string",
                              "subresource_uris"=>{} }

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Messages.json").
      with(body: {"Body"=>"RB This is the ship that made the Kesssssel Run in fourteen parsecs?", "From"=>"+13212855389", "To"=>"+593978613041"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messages.create(to: "+593978613041", body: "RB This is the ship that made the Kesssssel Run in fourteen parsecs?", from: "+13212855389")

    assert Time, response.date_created.class
    assert Time, response.date_updated.class
    assert Time, response.date_sent.class

    assert "SM", response.sid[0,2]
  end

  def test_mock_client_message_mms
    mock_server_response = { "body"=>"string",
                              "num_segments"=>"string",
                              "direction"=>"inbound",
                              "from"=>"string",
                              "to"=>"string",
                              "date_updated"=>"string",
                              "price"=>"string",
                              "error_message"=>"string",
                              "uri"=>"string",
                              "account_sid"=>"stringstringstringstringstringstri",
                              "num_media"=>"string",
                              "status"=>"queued",
                              "messaging_service_sid"=>"stringstringstringstringstringstri",
                              "sid"=>"stringstringstringstringstringstri",
                              "date_sent"=>"string",
                              "date_created"=>"string",
                              "error_code"=>0,
                              "price_unit"=>"string",
                              "api_version"=>"string",
                              "subresource_uris"=>{} }

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Messages.json").
      with(body: {"Body"=>"RB This is the ship that made the Kesssssel Run in fourteen parsecs?", "From"=>"+13212855389", "MediaUrl"=>"sample", "To"=>"+593978613041"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messages.create(to: "+593978613041", body: "RB This is the ship that made the Kesssssel Run in fourteen parsecs?", from: "+13212855389", media_url: ["sample"])

    assert Time, response.date_created.class
    assert Time, response.date_updated.class
    assert Time, response.date_sent.class

    assert "MM", response.sid[0,2]
  end
end
