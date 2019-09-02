# frozen_string_literal: true

class Nexmo::Numbers::Response < Nexmo::Response
  def success?
    error_code == '200'
  end
end
