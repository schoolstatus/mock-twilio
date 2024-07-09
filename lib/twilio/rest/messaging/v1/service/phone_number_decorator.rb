Twilio::REST::Messaging::V1::ServiceContext::PhoneNumberList.class_eval do
  def list(limit: nil, page_size: nil)
    self.stream(
      limit: 1,
      page_size: page_size
    ).entries
  end
end
