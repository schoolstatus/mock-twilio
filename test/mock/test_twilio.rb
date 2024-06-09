# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mock::Twilio::VERSION
  end

  def test_mock_client
    mock_client = Mock::Twilio::Client.new

    assert "twilio_mock_server", mock_client.proxy_addr
    assert "http", mock_client.proxy_port
    assert "4010", mock_client.proxy_port
  end


  def test_mock_client_error
    mock_server_response = { "type"=>"https://stoplight.io/prism/errors#UNPROCESSABLE_ENTITY",
                             "title"=>"Invalid request",
                             "status"=>422,
                             "detail"=>"Your request is not valid and no HTTP validation response was found in the spec, so Prism is generating this error for you.",
                             "validation"=>[{"location"=>["path", "accountsid"], "severity"=>"Error", "code"=>"minLength", "message"=>"Request path parameter accountsid must NOT have fewer than 34 characters"}, {"location"=>["path", "accountsid"], "severity"=>"Error", "code"=>"pattern", "message"=>"Request path parameter accountsid must match pattern \"^AC[0-9a-fA-F]{32}$\""}]}

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/BADTOKEN/Messages.json").
      with(
        body: {"Body"=>"RB This is the ship that made the Kesssssel Run in fourteen parsecs?", "From"=>"+13212855389", "To"=>"+593978613041"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QkFEVE9LRU46U0tYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWA==',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/7.1.1 (linux x86_64) Ruby/3.2.3'
        }).
        to_return(status: 422, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new('BADTOKEN', nil, nil, nil, mock_client)

    assert_raises(Twilio::REST::RestError) { client.messages.create(to: "+593978613041", body: "RB This is the ship that made the Kesssssel Run in fourteen parsecs?", from: "+13212855389") }
  end
end
