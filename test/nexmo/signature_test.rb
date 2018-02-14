require 'minitest/autorun'
require 'nexmo/signature'

class NexmoSignatureTest < Minitest::Test
  def secret
    'secret'
  end

  def test_check_method_returns_true_if_given_params_has_correct_sig_value
    params = {'a' => '1', 'b' => '2', 'timestamp' => '1461605396', 'sig' => '6af838ef94998832dbfc29020b564830'}

    assert_equal Nexmo::Signature.check(params, secret), true
  end

  def test_check_method_returns_false_otherwise
    params = {'a' => '1', 'b' => '2', 'timestamp' => '1461605396', 'sig' => 'xxx'}

    assert_equal Nexmo::Signature.check(params, secret), false
  end
end
