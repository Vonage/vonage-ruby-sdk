require_relative '../test'

class Nexmo::Verify::ResponseTest < Minitest::Test
  def build_response(attributes)
    Nexmo::Verify::Response.new(Nexmo::Entity.new(attributes))
  end

  def test_success_method
    response = build_response(status: '0')
    assert response.success?

    response = build_response(status: 'SUCCESS')
    assert response.success?

    response = build_response(status: 'CANCELLED')
    assert response.success?

    response = build_response(status: '19', error_text: 'Cannot be cancelled')
    refute response.success?

    response = build_response(status: '101', error_text: 'No response found')
    refute response.success?
  end
end
