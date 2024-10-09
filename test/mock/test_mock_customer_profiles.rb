# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  HOST = Mock::Twilio.host

  def test_mock_client_customer_profiles
    mock_server_response =  { "sid"=>"stringstringstringstringstringstri",
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

    stub_request(:post, "http://twilio_mock_server:4010/v1/CustomerProfiles").
      with(body: {"Email"=>"test@test.com", "FriendlyName"=>"Test friendly_name", "PolicySid"=>"RNFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "StatusCallback"=>"http://host.com/webhooks/twilio/customer_profiles_compliance"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    twilio_attributes = {
      status_callback: "http://host.com/webhooks/twilio/customer_profiles_compliance",
      friendly_name: "Test friendly_name",
      email: "test@test.com",
      policy_sid: "RNFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
    }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response =  client.trusthub.v1.customer_profiles.create(**twilio_attributes)


    assert_equal Time, response.date_created.class
    assert_equal Time, response.date_updated.class

    assert_equal "BU", response.sid[0,2]
    assert_equal "RN", response.policy_sid[0,2]
  end

  def test_mock_client_customer_profiles_entity_assignments
    mock_server_response =  { "sid"=>"stringstringstringstringstringstri",
                              "customer_profile_sid"=>"stringstringstringstringstringstri",
                              "account_sid"=>"stringstringstringstringstringstri",
                              "object_sid"=>"stringstringstringstringstringstri",
                              "date_created"=>"2019-08-24T14:15:22Z",
                              "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/CustomerProfiles/BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/EntityAssignments").
      with(body: {"ObjectSid"=>"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.customer_profiles("BUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
      .customer_profiles_entity_assignments.create(object_sid: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    assert_equal "BV", response.sid[0,2]
    assert_equal "BU", response.customer_profile_sid[0,2]
  end

  def test_mock_client_customer_profiles_evaluations
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "policy_sid"=>"stringstringstringstringstringstri",
                             "customer_profile_sid"=>"stringstringstringstringstringstri",
                             "status"=>"compliant",
                             "results"=>[nil],
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/CustomerProfiles/BUaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/Evaluations").
      with(body: {"PolicySid"=>"RNaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.customer_profiles("BUaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
      customer_profiles_evaluations.create(policy_sid: "RNaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    assert_equal "EL", response.sid[0,2]
    assert_equal "BU", response.customer_profile_sid[0,2]
  end

  def test_mock_client_customer_profiles_updates
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

    stub_request(:post, "http://twilio_mock_server:4010/v1/CustomerProfiles/BU8f9119bc8f39527dacf01b65b9acb329").
      with(body: {"Status"=>"pending-review"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.customer_profiles("BU8f9119bc8f39527dacf01b65b9acb329").update(status: "pending-review")

    assert_equal "BU", response.sid[0,2]
    assert_equal "pending-review", response.status
  end

  def test_mock_client_customer_profiles_channel_endpoint_assignments
    mock_server_response = {
      "results" => [
        {
          "sid" => "stringstringstringstringstringstri",
          "customer_profile_sid" => "stringstringstringstringstringstri",
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

    stub_request(:get, "http://twilio_mock_server:4010/v1/CustomerProfiles/BU8f9119bc8f39527dacf01b65b9acb329/ChannelEndpointAssignments?PageSize=20").
      to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.customer_profiles("BU8f9119bc8f39527dacf01b65b9acb329").customer_profiles_channel_endpoint_assignment.list(limit: 20)

    response.each do |assignment|
      assert assignment.customer_profile_sid.match(%r{BU[0-9a-zA-Z]{32}})
      assert assignment.sid.match(%r{RA[0-9a-zA-Z]{32}})
      assert assignment.channel_endpoint_sid.match(%r{PN[0-9a-zA-Z]{32}})
      assert assignment.url.match(%r{https://trusthub\.twilio\.com/v1/CustomerProfiles/BU[0-9a-zA-Z]{32}/ChannelEndpointAssignments/RA[0-9a-zA-Z]{32}})
      assert_equal "phone-number", assignment.channel_endpoint_type
      assert_equal ::Twilio.account_sid, assignment.account_sid
      assert_equal Time, assignment.date_created.class
    end
  end
end
