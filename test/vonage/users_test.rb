# typed: false
require_relative './test'

class Vonage::UsersTest < Vonage::Test
  def users
    Vonage::Users.new(config)
  end

  def users_uri
    'https://api.nexmo.com/v1/users'
  end

  def user_uri
    'https://api.nexmo.com/v1/users/' + user_id
  end

  def test_list_method
    stub_request(:get, users_uri).with(request).to_return(users_response)

    response = users.list

    assert_kind_of Vonage::Users::ListResponse, response
    response.each{|resp| assert_kind_of Vonage::Response, resp }
  end

  def test_list_method_with_optional_params
    stub_request(:get, users_uri + '?order=asc').with(request).to_return(users_response)

    response = users.list(order: 'asc')

    assert_kind_of Vonage::Users::ListResponse, response
    response.each{|resp| assert_kind_of Vonage::Response, resp }
  end

  def test_find_method
    stub_request(:get, user_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, users.find(id: user_id)
  end

  def test_find_method_without_id
    assert_raises ArgumentError do
      users.find
    end
  end

  def test_create_method
    stub_request(:post, users_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, users.create
  end

  def test_create_method_with_optional_params
    params = {name: 'USR-1234'}

    stub_request(:post, users_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, users.create(**params)
  end

  def test_update_method
    skip
    params = {id: user_id}

    stub_request(:patch, user_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, users.update(**params)
  end

  def test_update_method_with_optional_params
    skip
    params = {id: user_id, display_name: 'Foo'}

    stub_request(:patch, user_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, users.update(**params)
  end

  def test_update_method_without_id
    skip
    assert_raises ArgumentError do
      users.update
    end
  end

  def test_delete_method
    skip
    stub_request(:delete, user_id).with(request).to_return(status: 204)

    assert_kind_of Vonage::Response, users.delete(id: user_id)
  end

  def test_delete_method_without_id
    skip
    assert_raises ArgumentError do
      users.delete
    end
  end
end
