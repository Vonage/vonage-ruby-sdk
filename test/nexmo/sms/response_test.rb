# typed: false
require_relative '../test'

class Nexmo::SMS::ResponseTest < Minitest::Test
  def build_response(items)
    messages = items.map { |hash| Nexmo::Entity.new(hash) }

    Nexmo::SMS::Response.new(Nexmo::Entity.new(messages: messages))
  end

  def test_success_method
    response = build_response([{status: '0'}])
    assert response.success?

    response = build_response([{status: '2'}])
    refute response.success?

    response = build_response([{status: '0'}, {status: '2'}])
    refute response.success?
  end
end
