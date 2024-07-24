# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_messaging_services_phone_numbers_list
    mock_server_response = { "phone_numbers"=>
                             [{"sid"=>"stringstringstringstringstringstri",
                               "account_sid"=>"stringstringstringstringstringstri",
                               "service_sid"=>"stringstringstringstringstringstri",
                               "date_created"=>"2019-08-24T14:15:22Z",
                               "date_updated"=>"2019-08-24T14:15:22Z",
                               "phone_number"=>"string",
                               "country_code"=>"string",
                               "capabilities"=>["string"],
                               "url"=>"http://example.com"}],
                               "meta"=>
                             {"first_page_url"=>"http://example.com",
                              "next_page_url"=>"http://example.com",
                              "page"=>0,
                              "page_size"=>0,
                              "previous_page_url"=>"http://example.com",
                              "url"=>"http://example.com",
                              "key"=>"string"}}

    stub_request(:get, "http://twilio_mock_server:4010/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers?PageSize=1").
      with(
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json , headers: {})


    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messaging.v1.services("MG"+"F"*32).phone_numbers.list(limit: nil)

    assert_equal Time, response.first.date_created.class
    assert_equal Time, response.first.date_updated.class

    assert_equal "PN", response.first.sid[0,2]
    assert_equal "AC", response.first.account_sid[0,2]
    assert_equal "MG", response.first.service_sid[0,2]
  end

  def test_mock_client_messaging_services_phone_numbers_create
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "service_sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "phone_number"=>"string",
                             "country_code"=>"string",
                             "capabilities"=>["string"],
                             "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers").
      with(
        body: {"PhoneNumberSid"=>"PN09b2256564096ff183b0238a545e22f2"},
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messaging.v1.services("MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF").phone_numbers.create(phone_number_sid: "PN09b2256564096ff183b0238a545e22f2")

    assert_equal Time, response.date_created.class
    assert_equal Time, response.date_updated.class

    assert_equal "PN", response.sid[0,2]
    assert_equal "AC", response.account_sid[0,2]
    assert_equal "MG", response.service_sid[0,2]
    assert_equal 11, response.phone_number.length
  end

  def test_mock_client_messaging_services_phone_numbers_fetch
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "service_sid"=>"stringstringstringstringstringstri",
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "phone_number"=>"string",
                             "country_code"=>"string",
                             "capabilities"=>["string"],
                             "url"=>"http://example.com"}


    stub_request(:get, "http://twilio_mock_server:4010/v1/Services/MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF/PhoneNumbers/PN09b2256564096ff183b0238a545e22f2").
      with(
        headers: {
          'Accept'=>'application/json',
          'Accept-Charset'=>'utf-8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Basic QUNGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRkZGRjpTS1hYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhY',
          'User-Agent'=>'twilio-ruby/7.1.0 (linux x86_64) Ruby/3.2.2'
        }).
        to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.messaging.v1.services('MGFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF').phone_numbers('PN09b2256564096ff183b0238a545e22f2').fetch

    assert_equal Time, response.date_created.class
    assert_equal Time, response.date_updated.class

    assert_equal "PN", response.sid[0,2]
    assert_equal "AC", response.account_sid[0,2]
    assert_equal "MG", response.service_sid[0,2]
    assert_equal 11, response.phone_number.length
  end
end
