# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  include Mock::Twilio::Generator

  def test_mock_available_phone_numbers_local_list
    mock_server_response = {
      "available_phone_numbers" => [
        {
          "friendly_name" => "string",
          "phone_number" => "string",
          "lata" => "string",
          "locality" => "string",
          "rate_center" => "string",
          "latitude" => 0,
          "longitude" => 0,
          "region" => "string",
          "postal_code" => "string",
          "iso_country" => "string",
          "address_requirements" => "string",
          "beta" => true,
          "capabilities" => {
            "mms" => true,
            "sms" => true,
            "voice" => true,
            "fax" => true
          }
        }
      ],
      "end" => 0,
      "first_page_uri" => "http://example.com",
      "next_page_uri" => "http://example.com",
      "page" => 0,
      "page_size" => 0,
      "previous_page_uri" => "http://example.com",
      "start" => 0,
      "uri" => "http://example.com"
    }

    stub_request(:get, "http://twilio_mock_server:4010/2010-04-01/Accounts/#{Twilio.account_sid}/AvailablePhoneNumbers/US/Local.json?MmsEnabled=true&PageSize=1&SmsEnabled=true").
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(Twilio.account_sid, SecureRandom.hex(16), nil, nil, mock_client)
    response = client.available_phone_numbers("US").local.list(limit: 1, sms_enabled: true, mms_enabled: true)

    response.each do |number|
      assert_equal number.address_requirements, "none"
      assert number.friendly_name.match(/\([0-9]{3}\) [0-9]{3}-[0-9]{4}/)
      assert_equal number.iso_country, "US"
      assert number.lata.match(%r{[0-9]{3}})
      assert number.latitude.match(%r{^[-+]?[0-9]*\.?[0-9]+$})
      assert number.longitude.match(%r{^[-+]?[0-9]*\.?[0-9]+$})
      assert_equal number.locality, "Hilo"
      assert number.postal_code.match(%r{[0-9]{5}})
      assert_equal number.rate_center, "HILO"
      assert_equal number.region, "HI"
      assert number.phone_number.match(/\+1[0-9]{10}/)
    end
  end
end
