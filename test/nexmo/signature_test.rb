require_relative './test'

class NexmoSignatureTest < Minitest::Test
  def secret
    'secret'
  end

  def params
    {'a' => '1', 'b' => '2', 'timestamp' => '1461605396'}
  end

  def params_with_valid_signature
    params.merge('sig' => '6af838ef94998832dbfc29020b564830')
  end

  def params_with_invalid_signature
    params.merge('sig' => 'xxx')
  end

  def test_check_class_method
    assert_equal Nexmo::Signature.check(params_with_valid_signature, secret), true
    assert_equal Nexmo::Signature.check(params_with_invalid_signature, secret), false
  end

  def test_check_instance_method
    client = Nexmo::Client.new(signature_secret: secret)

    signature = Nexmo::Signature.new(client)

    assert_equal signature.check(params_with_valid_signature), true
    assert_equal signature.check(params_with_invalid_signature), false
  end
end
