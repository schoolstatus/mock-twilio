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
      with(
        body: {"Email"=>"test@test.com", "FriendlyName"=>"Test friendly_name", "PolicySid"=>"RNFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", "StatusCallback"=>"http://host.com/webhooks/twilio/customer_profiles_compliance"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/6.7.1 (linux x86_64) Ruby/3.2.2'
        }).
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
      with(
        body: {"ObjectSid"=>"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/6.7.1 (linux x86_64) Ruby/3.2.2'
        }).
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
      with(
        body: {"PolicySid"=>"RNaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/6.7.1 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.customer_profiles("BUaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").
      customer_profiles_evaluations.create(policy_sid: "RNaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

    assert_equal "EL", response.sid[0,2]
    assert_equal "BU", response.customer_profile_sid[0,2]
  end
end
