# typed: true
# frozen_string_literal: true

class Vonage::Numbers::Response < Vonage::Response
  def success?
    T.unsafe(self).error_code == '200'
  end
end
