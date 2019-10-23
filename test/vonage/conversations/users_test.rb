# typed: false
require_relative '../test'

class Vonage::Conversations::UsersTest < Vonage::Test
  def users
    Vonage::Conversations::Users.new(config)
  end

  def users_uri
    'https://api.nexmo.com/v0.1/users'
  end

  def user_uri
    'https://api.nexmo.com/v0.1/users/' + user_id
  end

  def params
    {display_name: 'My User Name'}
  end

  def error_params
    {}
  end

  def test_create_method
    stub_request(:post, users_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, users.create(params)
  end

  def test_create_method_with_error
    stub_request(:post, users_uri).with(request(body: error_params)).to_return(error_response)

    assert_raises Vonage::ClientError do
      users.create(error_params)
    end
  end

  def test_list_method
    stub_request(:get, users_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, users.list
  end

  def test_get_method
    stub_request(:get, user_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, users.get(user_id)
  end

  def test_update_method
    stub_request(:put, user_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, users.update(user_id, params)
  end

  def test_update_method_with_error
    stub_request(:put, user_uri).with(request(body: error_params)).to_return(error_response)

    assert_raises Vonage::ClientError do
      users.update(user_id, error_params)
    end
  end

  def test_delete_method
    stub_request(:delete, user_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, users.delete(user_id)
  end
end
