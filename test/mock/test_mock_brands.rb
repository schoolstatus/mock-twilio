# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test

  def test_mock_brands
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "customer_profile_bundle_sid"=>"stringstringstringstringstringstri",
                             "a2p_profile_bundle_sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "brand_type"=>"string",
                             "status"=>"PENDING",
                             "tcr_id"=>"string",
                             "failure_reason"=>"string",
                             "errors"=>[nil],
                             "url"=>"http://example.com",
                             "brand_score"=>0,
                             "brand_feedback"=>["TAX_ID"],
                             "identity_status"=>"SELF_DECLARED",
                             "russell_3000"=>true,
                             "government_entity"=>true,
                             "tax_exempt_status"=>"string",
                             "skip_automatic_sec_vet"=>true,
                             "mock"=>true,
                             "links"=>{}}

    stub_request(:post, "http://twilio_mock_server:4010/v1/a2p/BrandRegistrations").
      with(body: {"A2PProfileBundleSid"=>"BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "BrandType"=>"STANDARD", "CustomerProfileBundleSid"=>"BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "Mock"=>"true"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    twilio_params = { customer_profile_bundle_sid: "BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                      a2p_profile_bundle_sid: "BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                      brand_type: 'STANDARD',
                      mock: true }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messaging.v1.brand_registrations.create(**twilio_params)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "BN", response.sid[0,2]
    assert_equal "PENDING", response.status
    assert_equal "STANDARD", response.brand_type
    assert_equal "SELF_DECLARED", response.identity_status
  end
end
