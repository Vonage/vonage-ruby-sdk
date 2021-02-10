# typed: false
require_relative '../test'

class Vonage::Numbers::ResponseTest < Minitest::Test
  def build_response(attributes)
    Vonage::Numbers::Response.new(Vonage::Entity.new(attributes))
  end

  def test_success_method
    response = build_response(error_code: '200')
    assert response.success?

    response = build_response(error_code: '401')
    refute response.success?
  end
end
