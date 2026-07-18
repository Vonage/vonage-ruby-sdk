# frozen_string_literal: true

class Vonage::Numbers::Response < Vonage::Response
  def success?
    self.error_code == '200'
  end
end
