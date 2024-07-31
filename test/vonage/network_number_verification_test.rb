# typed: false
require_relative './test'

class Vonage::NetworkNumberVerificationTest < Vonage::Test
  def network_number_verification
    Vonage::NetworkNumberVerification.new(config)
  end

  def uri
    'https://api-eu.vonage.com/camara/number-verification/v031'
  end

  def phone_number
    '+447900000000'
  end

  def hashed_phone_number
    '32f67ab4e4312618b09cd23ed8ce41b13e095fe52b73b2e8da8ef49830e50dba'
  end

  def example_redirect_uri
    'https://example.com/callback'
  end

  def example_oidc_auth_code
    '0dadaeb4-7c79-4d39-b4b0-5a6cc08bf537'
  end

  def test_verify_method
    request_access_token_request_params = {
      grant_type: 'authorization_code',
      code: example_oidc_auth_code,
      redirect_uri: example_redirect_uri
    }

    number_verification_verify_params = {phoneNumber: phone_number}

    stub_request(:post, "https://api-eu.vonage.com/oauth2/token").with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)
    stub_request(:post, uri + '/verify').with(body: number_verification_verify_params).to_return(response)

    response = network_number_verification.verify(
      phone_number: phone_number,
      auth_data: {
        oidc_auth_code: example_oidc_auth_code,
        redirect_uri: example_redirect_uri
      }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_verify_method_with_hashed_phone_number
    request_access_token_request_params = {
      grant_type: 'authorization_code',
      code: example_oidc_auth_code,
      redirect_uri: example_redirect_uri
    }

    number_verification_verify_params = {hashedPhoneNumber: hashed_phone_number}

    stub_request(:post, "https://api-eu.vonage.com/oauth2/token").with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)
    stub_request(:post, uri + '/verify').with(body: number_verification_verify_params).to_return(response)

    response = network_number_verification.verify(
      phone_number: hashed_phone_number,
      hashed: true,
      auth_data: {
        oidc_auth_code: example_oidc_auth_code,
        redirect_uri: example_redirect_uri
      }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_check_method_without_phone_number
    assert_raises(ArgumentError) do
      network_number_verification.verify(
      auth_data: {
        oidc_auth_code: example_oidc_auth_code,
        redirect_uri: example_redirect_uri
      }
    )
    end
  end

  def test_check_method_with_invalid_phone_number
    auth_data = {
      oidc_auth_code: example_oidc_auth_code,
      redirect_uri: example_redirect_uri
    }

    assert_raises(TypeError) { network_number_verification.verify(phone_number: 447904603505, auth_data: auth_data) }
    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: '07904603505', auth_data: auth_data) }
    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: '447904603505', auth_data: auth_data) }
  end

  def test_check_method_with_invalid_hashed
    auth_data = {
      oidc_auth_code: example_oidc_auth_code,
      redirect_uri: example_redirect_uri
    }

    assert_raises(TypeError) { network_number_verification.verify(phone_number: hashed_phone_number, auth_data: auth_data, hashed: 'true') }
  end

  def test_check_method_without_auth_data
    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: phone_number) }
  end

  def test_check_method_with_invalid_auth_data
    auth_data = [
      example_oidc_auth_code,
      example_redirect_uri
    ]

    assert_raises(TypeError) { network_number_verification.verify(phone_number: phone_number, auth_data: auth_data) }
  end

  def test_check_method_without_oidc_auth_code
    auth_data = {
      redirect_uri: example_redirect_uri
    }

    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: phone_number, auth_data: auth_data) }
  end

  def test_check_method_with_invalid_oidc_auth_code
    auth_data = {
      oidc_auth_code: 12345,
      redirect_uri: example_redirect_uri
    }

    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: phone_number, auth_data: auth_data) }
  end

  def test_check_method_without_redirect_uri
    auth_data = {
      oidc_auth_code: example_oidc_auth_code
    }

    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: phone_number, auth_data: auth_data) }
  end

  def test_check_method_with_invalid_redirect_uri
    auth_data = {
      oidc_auth_code: example_oidc_auth_code,
      redirect_uri: 12345
    }

    assert_raises(ArgumentError) { network_number_verification.verify(phone_number: phone_number, auth_data: auth_data) }
  end
end
