# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_mock_client_supporting_documents
    mock_server_response = { "sid"=>"stringstringstringstringstringstri",
                             "account_sid"=>"stringstringstringstringstringstri",
                             "friendly_name"=>"string",
                             "mime_type"=>"string",
                             "status"=>"draft",
                             "type"=>"string",
                             "attributes"=>nil,
                             "date_created"=>"2019-08-24T14:15:22Z",
                             "date_updated"=>"2019-08-24T14:15:22Z",
                             "url"=>"http://example.com"}

    stub_request(:post, "http://twilio_mock_server:4010/v1/SupportingDocuments").
      with(body: {"Attributes"=>"[]", "FriendlyName"=>"friendly_name", "Type"=>"business"}).
      to_return(status: 200, body: mock_server_response.to_json, headers: {})

    payload = {
      friendly_name: "friendly_name",
      type: "business",
      attributes: []
    }

    mock_client = Mock::Twilio::Client.new
    client = ::Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
    response = client.trusthub.v1.supporting_documents.create(**payload)

    assert Time, response.date_created.class
    assert Time, response.date_updated.class

    assert_equal "RD", response.sid[0,2]
    assert_equal "approved", response.status
  end
end
