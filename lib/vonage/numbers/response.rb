# typed: false
# frozen_string_literal: true

class Vonage::Numbers::Response < Vonage::Response
  def success?
    error_code == '200'
  end
end
