# typed: false
require_relative './test'

class Vonage::JWTTest < Minitest::Test
  def private_key
    @private_key ||= File.read('test/private_key.txt')
  end

  def application_id
    @application_id ||= SecureRandom.uuid
  end

  def uuid_pattern
    /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
  end

  def sample_token
    'eyJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1OTUyNTM2MTMsImp0aSI6ImU1QmxGeDVOek5ydCIsImV4cCI6MTU5NTI1NDUxMywic3ViIjoiU3ViamVjdCIsImFwcGxpY2F0aW9uX2lkIjoieHh4eHh4eHgteHh4eC14eHh4LXh4eHgteHh4eHh4eHh4eHh4IiwidHlwIjoiSldUIn0.wQ_WHt4ba2nDWN-ju7D8VdGg6JdpVdcU2-bzvS_CMg_KVxaaD8NoYDMnIdrf4f4mOJThnmDiWvGOLFSmyqTtgN_qniCsoSL0ZnLFhvb1HWbSYsmNlOb8ePB0AkvQM-wcfHOfgToXU5tCe3OXV5s7sUDRlFEKAS4s8qzdTUAoJw5I2-RjVP9hlumV0Cda1yFyOiM1ppsV09OxbeXqKU_NLFm8XNqe_bIlB2d2XIuwtfluGXjsgPM8R2stF_hS0Q65oILue0Yru1N-IbemvLmh8Rs4hSfEKQrmabRIMOvfXdQAVTW_0g1OsGRRUsT8RAwDdcC1LB_CrktYP_o3Pp9qxA'
  end

  def decode(token)
    JWT.decode(token, private_key, false, {algorithm: 'RS256'}).first
  end

  def test_generate_method_returns_payload_encoded_with_private_key
    time = Timecop.freeze(Time.now).to_i

    payload = {
      :application_id => application_id,
      :private_key => private_key,
      :jti => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    }

    token = Vonage::JWT.generate(payload)
    decoded = decode(token)

    assert_equal decoded.fetch('application_id'), payload.fetch(:application_id)
    assert_equal decoded.fetch('iat'), time
    assert_equal decoded.fetch('jti'), payload.fetch(:jti)
  end

  def test_generate_method_sets_default_value_for_iat_parameter
    token = Vonage::JWT.generate({ :application_id => application_id }, private_key)

    assert_kind_of Integer, decode(token).fetch('iat')
  end

  def test_generate_method_sets_default_value_for_exp_parameter
    token = Vonage::JWT.generate({ :application_id => application_id }, private_key)

    assert_kind_of Integer, decode(token).fetch('exp')
  end

  def test_generate_method_sets_default_value_for_jti_parameter
    token = Vonage::JWT.generate({ :application_id => application_id }, private_key)

    assert_match uuid_pattern, decode(token).fetch('jti')
  end

  def test_generate_method_sets_provided_value_for_ttl_parameter
    Timecop.freeze(Time.at(1595253613))

    payload = {
      :application_id => application_id,
      :private_key => private_key,
      :ttl => 700
    }

    token = Vonage::JWT.generate(payload)
    decoded = decode(token)

    assert_equal decoded.fetch('exp'), 1595254313
  end

  def test_generate_method_jwt_string_comparison
    Timecop.freeze(Time.at(1595253613))

    token = Vonage::JWT.generate({ :application_id => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', :jti => 'e5BlFx5NzNrt' }, private_key)
    decoded = decode(token)

    assert_equal token, sample_token
  end

  def test_exception_behavior_without_private_key
    payload = {
      :application_id => application_id
    }

    exception = assert_raises { Vonage::JWT.generate(payload) }

    assert_match "Expecting 'private_key' in either the payload or as a separate parameter", exception.message
  end

  def test_no_exception_with_private_key_in_payload
    payload = {
      :application_id => application_id,
      :private_key => private_key
    }

    token = Vonage::JWT.generate(payload)

    assert token
  end

  def test_no_exception_with_private_key_in_second_argument
    payload = {
      :application_id => application_id
    }

    token = Vonage::JWT.generate(payload, private_key)

    assert token
  end
end
