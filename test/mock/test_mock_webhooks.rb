# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_webhook_message_trigger
    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_requests/webhook_message_updates").
      with(
        body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"},
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'Host'=>'forwarded_host.app',
          'User-Agent'=>'Faraday v2.9.1',
          'X-Forwarded-Proto'=>'http',
          'X-Twilio-Signature'=>'WNqVAu7AugB+SUKrULuBh6cyOKM='
        }).
        to_return(status: 200, body: "", headers: {})

    response = Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING")

    assert "forwarded_host.app", response.env.request_headers['Host']
    assert "http", response.env.request_headers['X-forwarded-proto']
    assert "WNqVAu7AugB+SUKrULuBh6cyOKM=", response.env.request_headers['X-twilio-signature']
    assert "MessageSid=SIDTESTING&MessageStatus=delivered", response.env.request_body
  end

  def test_mock_webhook_message_trigger_error
    service_response = {"error"=>{"code"=>50001,
                                  "message"=>"There was an error related with the Twilio API",
                                  "detail"=>"Invalid Twilio Token, verify the signature"}}

    stub_request(:post, "http://shunkan-ido-service:3000/api/v1/twilio_requests/webhook_message_updates").
      with(
        body: {"MessageSid"=>"SIDTESTING", "MessageStatus"=>"delivered"},
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'Host'=>'forwarded_host.app',
          'User-Agent'=>'Faraday v2.9.1',
          'X-Forwarded-Proto'=>'http',
          'X-Twilio-Signature'=>'WNqVAu7AugB+SUKrULuBh6cyOKM='
        }).
        to_return(status: 500, body: service_response.to_json, headers: {})


    assert_raises(Mock::Twilio::Webhooks::RestError) { Mock::Twilio::Webhooks::Messages.trigger("SIDTESTING") }
  end
end
