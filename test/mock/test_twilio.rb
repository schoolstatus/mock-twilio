# frozen_string_literal: true

require "test_helper"

class Mock::TestTwilio < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mock::Twilio::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
