# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_lookups_v2
    mock_server_response = { "calling_country_code"=>"1",
                             "country_code"=>"US",
                             "phone_number"=>"string",
                             "national_format"=>"string",
                             "valid"=>true,
                             "validation_errors"=>[],
                             "caller_name"=>nil,
                             "sim_swap"=>nil,
                             "call_forwarding"=>nil,
                             "line_status"=>nil,
                             "line_type_intelligence"=>nil,
                             "identity_match"=>nil,
                             "reassigned_number"=>nil,
                             "sms_pumping_risk"=>nil,
                             "phone_number_quality_score"=>nil,
                             "pre_fill"=>nil,
                             "url"=>"http://example.com"}

    stub_request(:get, "http://twilio_mock_server:4010/v2/PhoneNumbers/+1123456789?Fields=line_type_intelligence").
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.lookups.v2.phone_numbers("+1123456789") .fetch(fields: :line_type_intelligence)

    assert_equal "mock", response.line_type_intelligence["type"]
    assert response.valid
  end
end
