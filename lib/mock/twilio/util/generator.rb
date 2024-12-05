# frozen_string_literal: true

module Mock
  module Twilio
    module Generator
      def phone_number_generator
        "+1" + rand(1000000000..9999999999).to_s
      end

      def friendly_number_generator
        "(#{rand(100..999)}) #{rand(100..999)}-#{rand(1000..9999)}"
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

      def random_longitude
        rand(MIN_LONGITUDE..MAX_LONGITUDE)
      end

      def random_latitude
        rand(MIN_LATITUDE..MAX_LATITUDE)
      end

      private

      MIN_LATITUDE = -90.0
      MAX_LATITUDE = 90.0
      MIN_LONGITUDE = -180.0
      MAX_LONGITUDE = 180.0

      def random_sid_prefixed_by(prefix)
        "#{prefix}#{SecureRandom.hex(16)}"
      end
    end
  end
end
