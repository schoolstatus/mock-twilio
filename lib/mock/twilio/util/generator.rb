# frozen_string_literal: true

module Mock
  module Twilio
    module Generator
      def phone_number_generator
        "+1" + rand(100000000..999999999).to_s
      end
    end
  end
end
