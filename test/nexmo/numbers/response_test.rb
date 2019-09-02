require_relative '../test'

class Nexmo::Numbers::ResponseTest < Minitest::Test
  def build_response(attributes)
    Nexmo::Numbers::Response.new(Nexmo::Entity.new(attributes))
  end

  def test_success_method
    response = build_response(error_code: '200')
    assert response.success?

    response = build_response(error_code: '401')
    refute response.success?
  end
end
