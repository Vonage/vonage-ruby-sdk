# typed: false
require_relative './test'

class Vonage::JWTTest < Vonage::Test
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
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1OTUyNTM2MTMsImp0aSI6ImU1QmxGeDVOek5ydCIsImV4cCI6MTU5NTI1NDUxMywiYXBwbGljYXRpb25faWQiOiJ4eHh4eHh4eC14eHh4LXh4eHgteHh4eC14eHh4eHh4eHh4eHgifQ.DurSM2It4XstunZd_PykqDW1EceX5pCCB3s1ER2_ljMkLZbNuMcMv3GvCnTdtNKhizMEjrH8PXyVSjENdKMjUscyyMISNzLKQMYM1vsHOIIeFQY0M90D2wEaAvHf7fUtPPbBPsOUsl3zMDCrpikDSvEnMXOlxNTkc7_xxCWjv1dQI5Fu7_6VE8xEXgLi0jCv3rEaA61CYlzGwVRFkAH9kkettJa3tl7ZyHNqgR4TM-9DmuPomNQ8ARgff3ab0NalVZougF4cgxQvvMqIOWhXfxkmU-OCAs86wVGDkapJ8TJt_NuUKcVAMfhnf9eLR3USVMnsz2oTRWcezKrJM63mQQ"
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

  def test_verify_hs256_signature_with_valid_secret
    verification = Vonage::JWT.verify_hs256_signature(token: sample_webhook_token, signature_secret: sample_valid_signature_secret)

    assert_equal(true, verification)
  end

  def test_verify_hs256_signature_with_invalid_secret
    verification = Vonage::JWT.verify_hs256_signature(token: sample_webhook_token, signature_secret: sample_invalid_signature_secret)

    assert_equal(false, verification)
  end
end
