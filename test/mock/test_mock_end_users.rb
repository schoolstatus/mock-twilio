# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_end_users
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "friendly_name"=>"string",
                             "type"=>"string",
                             "attributes"=>nil,
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/EndUsers").
      with(
        body: {"Attributes"=>"{}", "FriendlyName"=>"friendly_name", "Type"=>"authorized_representative_1"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})


    payload = {
      attributes: {},
      friendly_name: "friendly_name",
      type: "authorized_representative_1",
    }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.end_users.create(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "IT", response.sid[0,2]
  end
end
