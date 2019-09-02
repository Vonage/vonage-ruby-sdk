require_relative '../test'

class Nexmo::NumberInsight::ResponseTest < Minitest::Test
  def build_response(attributes)
    Nexmo::NumberInsight::Response.new(Nexmo::Entity.new(attributes))
  end

  def test_success_method
    response = build_response(status: 0)
    assert response.success?

    response = build_response(status: 1)
    refute response.success?
  end
end
