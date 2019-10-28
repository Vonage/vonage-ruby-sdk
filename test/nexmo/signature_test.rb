require_relative './test'

class NexmoSignatureTest < Minitest::Test
  def secret
    'secret'
  end

  def params
    {'a' => '1', 'b' => '2', 'timestamp' => '1461605396'}
  end

  def params_with_valid_signature_md5hash
    params.merge('sig' => '6af838ef94998832dbfc29020b564830')
  end

  def params_with_valid_signature_md5
    params.merge('sig' => 'c5725da0ac958d4e03a90f3eeefa1475')
  end

  def params_with_valid_signature_sha1
    params.merge('sig' => '879d0c829f44d32d29793187a8c9ec882a97dc0b')
  end

  def params_with_valid_signature_sha256
    params.merge('sig' => '21c048bfc4fdcd3532ceb8dc110779d0fd2b754ea38b9eeb4ac17800a09d9ccd')
  end

  def params_with_valid_signature_sha512
    params.merge('sig' => '022fb2c734fcffc959fe66cdd8b625b9783ae7c38e1c7cc90bbe0bdde25688bdfbf2dc98abbfac2d3ef73ce3cc305d30bfaba370c831059c6fc336c9557f0d75')
  end

  def params_with_invalid_signature
    params.merge('sig' => 'xxx')
  end

  def test_check_instance_method_with_md5hash
    signature = Nexmo::Signature.new(secret)

    assert_equal signature.check('md5hash', params_with_valid_signature_md5hash), true
    assert_equal signature.check('md5hash', params_with_invalid_signature), false
  end

  def test_check_instance_method_with_md5hmac
    signature = Nexmo::Signature.new(secret)

    assert_equal signature.check('md5', params_with_valid_signature_md5), true
    assert_equal signature.check('md5', params_with_invalid_signature), false
  end

  def test_check_instance_method_with_sha1
    signature = Nexmo::Signature.new(secret)

    assert_equal signature.check('sha1', params_with_valid_signature_sha1), true
    assert_equal signature.check('sha1', params_with_invalid_signature), false
  end

  def test_check_instance_method_with_sha256
    signature = Nexmo::Signature.new(secret)

    assert_equal signature.check('sha256', params_with_valid_signature_sha256), true
    assert_equal signature.check('sha256', params_with_invalid_signature), false
  end

  def test_check_instance_method_with_sha512
    signature = Nexmo::Signature.new(secret)

    assert_equal signature.check('sha512', params_with_valid_signature_sha512), true
    assert_equal signature.check('sha512', params_with_invalid_signature), false
  end

  def test_check_instance_method_with_unknown_method
    signature = Nexmo::Signature.new(secret)

    exception = assert_raises RuntimeError do
      signature.check('xxxx', params_with_valid_signature_md5)
    end

    assert_equal('Unknown signature algorithm: xxxx. Expected: md5hash, md5, sha1, sha256, or sha512.', exception.message)
  end
end
