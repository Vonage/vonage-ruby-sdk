require 'minitest/autorun'
require 'nexmo/params'

class NexmoParamsTest < Minitest::Test
  def test_encode_method_returns_urlencoded_string
    params = {'name' => 'Example App', 'type' => 'voice'}

    assert_equal Nexmo::Params.encode(params), 'name=Example+App&type=voice'
  end

  def test_encode_method_flattens_array_values
    params = {'ids' => %w[00A0B0C0 00A0B0C1 00A0B0C2]}

    assert_equal Nexmo::Params.encode(params), 'ids=00A0B0C0&ids=00A0B0C1&ids=00A0B0C2'
  end
end
