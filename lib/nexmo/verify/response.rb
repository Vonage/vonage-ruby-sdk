# typed: false
class Nexmo::Verify::Response < Nexmo::Response
  def success?
    respond_to?(:status) && !respond_to?(:error_text)
  end
end
