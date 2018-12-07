require_relative './test'

class NexmoParamsTest < Minitest::Test
  def test_encode_method_returns_urlencoded_string
    params = {'name' => 'Example App', 'type' => 'voice'}

    assert_equal Nexmo::Params.encode(params), 'name=Example+App&type=voice'
  end

  def test_encode_method_flattens_array_values
    params = {'ids' => %w[00A0B0C0 00A0B0C1 00A0B0C2]}

    assert_equal Nexmo::Params.encode(params), 'ids=00A0B0C0&ids=00A0B0C1&ids=00A0B0C2'
  end

  def test_join_method_concatenates_params
    assert_equal Nexmo::Params.join('a=b', {'c' => 'd'}), 'a=b&c=d'
  end

  def test_join_method_with_nil
    assert_equal Nexmo::Params.join(nil, {'c' => 'd'}), 'c=d'
  end
end
