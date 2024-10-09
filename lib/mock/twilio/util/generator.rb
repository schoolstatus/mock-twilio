# frozen_string_literal: true

module Mock
  module Twilio
    module Generator
      def phone_number_generator
        "+1" + rand(100000000..999999999).to_s
      end

      def random_phone_number_sid
        random_sid_prefixed_by "PN"
      end

      def random_account_sid
        random_sid_prefixed_by "AC"
      end

      def random_twiml_app_sid
        random_sid_prefixed_by "AP"
      end

      def random_identity_sid
        random_sid_prefixed_by "RI"
      end

      def random_address_sid
        random_sid_prefixed_by "AD"
      end

      def random_bundle_sid
        random_sid_prefixed_by "BU"
      end

      def random_assignment_sid
        random_sid_prefixed_by "RA"
      end

      private

      def random_sid_prefixed_by(prefix)
        "#{prefix}#{SecureRandom.hex(16)}"
      end
    end
  end
end
