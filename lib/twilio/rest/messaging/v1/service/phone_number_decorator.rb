Twilio::REST::Messaging::V1::ServiceContext::PhoneNumberList.class_eval do
  def list(limit: nil, page_size: nil)
    limit = 1 if @version.domain.client.http_client.class == Mock::Twilio::Client

    self.stream(
      limit: limit,
      page_size: page_size
    ).entries
  end
end
