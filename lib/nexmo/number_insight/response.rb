class Nexmo::NumberInsight::Response < Nexmo::Response
  def success?
    status.zero?
  end
end
