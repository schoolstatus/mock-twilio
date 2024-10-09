# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_trust_products
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "policy_sid"=>"stringstringstringstringstringstri",
                             "friendly_name"=>"string",
                             "status"=>"draft",
                             "valid_until"=>"2019-08-24T14:15:22Z",
                             "email"=>"string",
                             "status_callback"=>"http://example.com",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com",
                             "links"=>{}}

    stub_request(:post, "http://twilio_mock_server:4010/v1/TrustProducts").
      with(body: {"Email"=>"test", "FriendlyName"=>"test", "PolicySid"=>"RNb0d4771c2c98518d923b3d4cd70a8f8b"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    twilio_attributes = { friendly_name: "test", email:"test", policy_sid: "RNb0d4771c2c98518d923b3d4cd70a8f8b"}
    response = client.trusthub.v1.trust_products.create(**twilio_attributes)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "BU", response.sid[0,2]
    assert_equal "RN", response.policy_sid[0,2]
    assert_equal "test", response.friendly_name
    assert_equal "draft", response.status
  end

  def test_mock_client_trust_products_update
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "policy_sid"=>"stringstringstringstringstringstri",
                             "friendly_name"=>"string",
                             "status"=>"draft",
                             "valid_until"=>"2019-08-24T14:15:22Z",
                             "email"=>"string",
                             "status_callback"=>"http://example.com",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com",
                             "links"=>{}}

    stub_request(:post, "http://twilio_mock_server:4010/v1/TrustProducts/BU8f9119bc8f39527dacf01b65b9acb329").
      with(body: {"Status"=>"pending-review"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.trust_products("BU8f9119bc8f39527dacf01b65b9acb329").update(status: "pending-review")

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "BU", response.sid[0,2]
    assert_equal "pending-review", response.status
  end


  def test_mock_client_trust_entity_assignments
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "trust_product_sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "object_sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com"}


    stub_request(:post, "http://twilio_mock_server:4010/v1/TrustProducts/BU8f9119bc8f39527dacf01b65b9acb329/EntityAssignments").
      with(body: {"ObjectSid"=>"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.trust_products("BU8f9119bc8f39527dacf01b65b9acb329")
      .trust_products_entity_assignments.create(object_sid: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    assert Time, response.date_created.class

    assert_equal "BV", response.sid[0,2]
    assert_equal "BU", response.trust_product_sid[0,2]
  end

  def test_mock_client_trust_evaluations
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "policy_sid"=>"stringstringstringstringstringstri",
                             "trust_product_sid"=>"stringstringstringstringstringstri",
                             "status"=>"compliant",
                             "results"=>[nil],
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/TrustProducts/BU9e5209e4eec0b3ff8303a0090ef934aa/Evaluations").
      with(body: {"PolicySid"=>"RN9e5209e4eec0b3ff8303a0090ef934aa"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.trust_products("BU9e5209e4eec0b3ff8303a0090ef934aa").trust_products_evaluations.create(policy_sid: "RN9e5209e4eec0b3ff8303a0090ef934aa")

    assert Time, response.date_created.class

    assert_equal "EL", response.sid[0,2]
    assert_equal "RN", response.policy_sid[0,2]
    assert_equal "BU", response.trust_product_sid[0,2]
    assert_equal "compliant", response.status
  end

  def test_mock_client_customer_profiles_channel_endpoint_assignments
    mock_server_response = {
      "results" => [
        {
          "sid" => "stringstringstringstringstringstri",
          "trust_product_sid" => "stringstringstringstringstringstri",
          "account_sid" => "stringstringstringstringstringstri",
          "channel_endpoint_type" => "string",
          "channel_endpoint_sid" => "stringstringstringstringstringstri",
          "date_created" => "2019-08-24T14:15:22Z",
          "url" => "http://example.com"
        }
      ],
      "meta" => {
        "first_page_url" => "http://example.com",
        "next_page_url" => "http://example.com",
        "page" => 0,
        "page_size" => 0,
        "previous_page_url" => "http://example.com",
        "url" => "http://example.com",
        "key" => "string"
      }
    }

    stub_request(:get, "http://twilio_mock_server:4010/v1/TrustProducts/BU8f9119bc8f39527dacf01b65b9acb329/ChannelEndpointAssignments?PageSize=20").
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.trust_products("BU8f9119bc8f39527dacf01b65b9acb329").trust_products_channel_endpoint_assignment.list(limit: 20)

    response.each do |assignment|
      assert assignment.trust_product_sid.match(%r{BU[0-9a-zA-Z]{32}})
      assert assignment.sid.match(%r{RA[0-9a-zA-Z]{32}})
      assert assignment.channel_endpoint_sid.match(%r{PN[0-9a-zA-Z]{32}})
      assert assignment.url.match(%r{https://trusthub\.twilio\.com/v1/TrustProducts/BU[0-9a-zA-Z]{32}/ChannelEndpointAssignments/RA[0-9a-zA-Z]{32}})
      assert_equal "phone-number", assignment.channel_endpoint_type
      assert_equal ::Twilio.account_sid, assignment.account_sid
      assert_equal Time, assignment.date_created.class
    end
  end
end
