# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_addresses
    mock_server_response = { "account_sid"=>"stringstringstringstringstringstri",
                             "city"=>"string",
                             "customer_name"=>"string",
                             "date_created"=>"string",
                             "date_updated"=>"string",
                             "friendly_name"=>"string",
                             "iso_country"=>"string",
                             "postal_code"=>"string",
                             "region"=>"string",
                             "sid"=>"stringstringstringstringstringstri",
                             "street"=>"string",
                             "uri"=>"string",
                             "emergency_enabled"=>true,
                             "validated"=>true,
                             "verified"=>true,
                             "street_secondary"=>"string"}

    stub_request(:post, "http://twilio_mock_server:4010/2010-04-01/Accounts/ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/Addresses.json").
      with(
        body: {"City"=>"city", "CustomerName"=>"customer_name", "FriendlyName"=>"friendly_name", "IsoCountry"=>"iso_country", "PostalCode"=>"postal_code", "Region"=>"region", "Street"=>"street", "StreetSecondary"=>"street_secondary"},
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
      friendly_name: "friendly_name",
      customer_name: "customer_name",
      street: "street",
      street_secondary: "street_secondary",
      city: "city",
      region: "region",
      postal_code: "postal_code",
      iso_country: "iso_country"
    }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.addresses.create(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "AD", response.sid[0,2]
    assert response.validated
    assert response.verified
  end
end
