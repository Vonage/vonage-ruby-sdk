# typed: false
require_relative './test'

class Vonage::ResponseTest < Minitest::Test
  def value
    'xxxx-xxxx'
  end

  def entity
    Vonage::Entity.new(id: value)
  end

  def test_http_response_method
    http_response = Net::HTTPOK.new('1.1', '200', 'OK')

    response = Vonage::Response.new(entity, http_response)

    assert_equal http_response.object_id, response.http_response.object_id
  end

  def test_respond_to_method
    response = Vonage::Response.new(entity)

    assert response.respond_to?(:id)
  end

  def test_method_missing_method
    response = Vonage::Response.new(entity)

    assert_equal response.id, value
  end
end
