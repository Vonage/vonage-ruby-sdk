# typed: false
require_relative './test'

class Nexmo::JWTTest < Minitest::Test
  def private_key
    @private_key ||= File.read('test/private_key.txt')
  end

  def application_id
    @application_id ||= SecureRandom.uuid
  end

  def uuid_pattern
    /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
  end

  def decode(token)
    JWT.decode(token, private_key, false, {algorithm: 'RS256'}).first
  end

  def test_generate_method_returns_payload_encoded_with_private_key
    time = Time.now.to_i

    payload = {
      :application_id => application_id,
      :private_key => private_key,
      :iat => time,
      :exp => time + 3600,
      :jti => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    }

    token = Nexmo::JWT.generate(payload)
    decoded = decode(token)

    assert_equal decoded.fetch('application_id'), payload.fetch(:application_id)
    assert_equal decoded.fetch('iat'), payload.fetch(:iat)
    assert_equal decoded.fetch('jti'), payload.fetch(:jti)
  end

  def test_generate_method_sets_default_value_for_iat_parameter
    token = Nexmo::JWT.generate({ :application_id => application_id }, private_key)

    assert_kind_of Integer, decode(token).fetch('iat')
  end

  def test_generate_method_sets_default_value_for_exp_parameter
    token = Nexmo::JWT.generate({ :application_id => application_id }, private_key)

    assert_kind_of Integer, decode(token).fetch('exp')
  end

  def test_generate_method_sets_default_value_for_jti_parameter
    token = Nexmo::JWT.generate({ :application_id => application_id }, private_key)

    assert_match uuid_pattern, decode(token).fetch('jti')
  end
end
