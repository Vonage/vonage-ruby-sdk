# typed: false
require_relative './test'

class Vonage::NetworkSIMSwapTest < Vonage::Test
  def network_sim_swap
    Vonage::NetworkSIMSwap.new(config)
  end

  def uri
    'https://api-eu.vonage.com/camara/sim-swap/v040'
  end

  def phone_number
    '+447900000000'
  end

  def test_check_method
    bc_authorize_request_params = {
      scope: "openid dpv:FraudPreventionAndDetection#check-sim-swap",
      login_hint: phone_number
    }

    request_access_token_request_params = {
      grant_type: 'urn:openid:params:grant-type:ciba',
      auth_req_id: network_authentication_auth_request_id
    }

    sim_swap_check_params = {phoneNumber: phone_number}

    stub_request(:post, "https://api-eu.vonage.com/oauth2/bc-authorize").with(request(body: bc_authorize_request_params, headers: headers)).to_return(network_authentication_oicd_response)
    stub_request(:post, "https://api-eu.vonage.com/oauth2/token").with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)
    stub_request(:post, uri + '/check').with(body: sim_swap_check_params).to_return(response)

    assert_kind_of Vonage::Response, network_sim_swap.check(phone_number: phone_number)
  end

  def test_check_method_with_optional_params
    bc_authorize_request_params = {
      scope: "openid dpv:FraudPreventionAndDetection#check-sim-swap",
      login_hint: phone_number
    }

    request_access_token_request_params = {
      grant_type: 'urn:openid:params:grant-type:ciba',
      auth_req_id: network_authentication_auth_request_id
    }

    sim_swap_check_params = {phoneNumber: phone_number, maxAge: 1200}

    stub_request(:post, "https://api-eu.vonage.com/oauth2/bc-authorize").with(request(body: bc_authorize_request_params, headers: headers)).to_return(network_authentication_oicd_response)
    stub_request(:post, "https://api-eu.vonage.com/oauth2/token").with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)
    stub_request(:post, uri + '/check').with(body: sim_swap_check_params).to_return(response)

    assert_kind_of Vonage::Response, network_sim_swap.check(phone_number: phone_number, max_age: 1200)
  end

  def test_check_method_without_phone_number
    assert_raises(ArgumentError) { network_sim_swap.check }
  end

  def test_check_method_with_invalid_phone_number
    assert_raises(TypeError) { network_sim_swap.check(phone_number: 447904603505) }
    assert_raises(ArgumentError) { network_sim_swap.check(phone_number: '07904603505') }
    assert_raises(ArgumentError) { network_sim_swap.check(phone_number: '447904603505') }
  end

  def test_check_method_with_invalid_max_age
    assert_raises(TypeError) { network_sim_swap.check(phone_number: phone_number, max_age: '1200') }
    assert_raises(ArgumentError) { network_sim_swap.check(phone_number: phone_number, max_age: 120000000) }
  end

  def test_retrieve_date_method
    bc_authorize_request_params = {
      scope: "openid dpv:FraudPreventionAndDetection#retrieve-sim-swap-date",
      login_hint: phone_number
    }

    request_access_token_request_params = {
      grant_type: 'urn:openid:params:grant-type:ciba',
      auth_req_id: network_authentication_auth_request_id
    }

    sim_swap_retrieve_date_params = {phoneNumber: phone_number}

    stub_request(:post, "https://api-eu.vonage.com/oauth2/bc-authorize").with(request(body: bc_authorize_request_params, headers: headers)).to_return(network_authentication_oicd_response)
    stub_request(:post, "https://api-eu.vonage.com/oauth2/token").with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)
    stub_request(:post, uri + '/retrieve-date').with(body: sim_swap_retrieve_date_params).to_return(response)

    assert_kind_of Vonage::Response, network_sim_swap.retrieve_date(phone_number: phone_number)
  end

  def test_retrieve_date_method_without_phone_number
    assert_raises(ArgumentError) { network_sim_swap.retrieve_date }
  end

  def test_retrieve_date_method_with_invalid_phone_number
    assert_raises(TypeError) { network_sim_swap.retrieve_date(phone_number: 447904603505) }
    assert_raises(ArgumentError) { network_sim_swap.retrieve_date(phone_number: '07904603505') }
    assert_raises(ArgumentError) { network_sim_swap.retrieve_date(phone_number: '447904603505') }
  end
end
