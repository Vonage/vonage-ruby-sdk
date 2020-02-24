# typed: false
# frozen_string_literal: true

class Nexmo::SMS::Response < Nexmo::Response
  def success?
    messages.all? { |item| item.status == '0' }
  end
end
