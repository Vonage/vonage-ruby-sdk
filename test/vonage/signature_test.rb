# typed: false
require_relative './test'

class Vonage::SignatureTest < Vonage::Test
  def signature_secret
    'my_secret_key_for_testing'
  end

  def signature
    Vonage::Signature.new(config)
  end

  def params
    {
      'message-timestamp' => '2013-11-21 15:27:30',
      'messageId' => '020000001B0FE827',
      'msisdn' => '14843472194',
      'text' => 'Test again',
      'timestamp' => '1385047698',
      'to' => '13239877404',
      'type' => 'text'
    }
  end

  def params_with_valid_signature_md5hash
    params.merge('sig' => 'd2e7b1dc968737c5998ad624e02f90b7')
  end

  def params_with_valid_signature_md5
    params.merge('sig' => 'DDEBD46008C2D4E93CCE578A332A52D5')
  end

  def params_with_valid_signature_sha1
    params.merge('sig' => '27D0D05C2876C7CB1720DBCDBA4D492E1E55C09A')
  end

  def params_with_valid_signature_sha256
    params.merge('sig' => 'DDB8397C2B90AAC7F3882D306475C9A5058C92322EEF43C92B298B6E0FC0D330')
  end

  def params_with_valid_signature_sha512
    params.merge('sig' => 'E0D3C650F8C9D1A5C174D10DDDBFB003E561F59B265616208B0487C5D819481CD3C311D59CF6165ECD1139622D5BA3A256C0D763AC4A9AD9144B5A426B94FE82')
  end

  def params_with_invalid_signature
    params.merge('sig' => 'xxx')
  end

  def test_check_instance_method_with_md5hash
    assert_equal signature.check(params_with_valid_signature_md5hash, signature_method: 'md5hash'), true
    assert_equal signature.check(params_with_invalid_signature, signature_method: 'md5hash'), false
  end

  def test_check_instance_method_with_md5hmac
    assert_equal signature.check(params_with_valid_signature_md5, signature_method: 'md5'), true
    assert_equal signature.check(params_with_invalid_signature, signature_method: 'md5'), false
  end

  def test_check_instance_method_with_sha1
    assert_equal signature.check(params_with_valid_signature_sha1, signature_method: 'sha1'), true
    assert_equal signature.check(params_with_invalid_signature, signature_method: 'sha1'), false
  end

  def test_check_instance_method_with_sha256
    assert_equal signature.check(params_with_valid_signature_sha256, signature_method: 'sha256'), true
    assert_equal signature.check(params_with_invalid_signature, signature_method: 'sha256'), false
  end

  def test_check_instance_method_with_sha512
    assert_equal signature.check(params_with_valid_signature_sha512, signature_method: 'sha512'), true
    assert_equal signature.check(params_with_invalid_signature, signature_method: 'sha512'), false
  end

  def test_check_instance_method_with_unknown_method
    exception = assert_raises ArgumentError do
      signature.check(params_with_valid_signature_md5, signature_method: 'xxxx')
    end

    assert_equal 'Unknown signature algorithm: xxxx. Expected: md5hash, md5, sha1, sha256, or sha512.', exception.message
  end

  def test_check_instance_method_replaces_disallowed_characters_with_underscores
    signature_value = 'c3d6a686ab9c7e7408bb1c0506e9629a'

    assert_equal signature.check({'k' => '_', 'sig' => signature_value}), true
    assert_equal signature.check({'k' => '&', 'sig' => signature_value}), true
    assert_equal signature.check({'k' => '=', 'sig' => signature_value}), true
  end
end
