# typed: false


class Vonage::Voice::Actions::ConnectTest < Vonage::Test
  def test_connect_initialize
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_kind_of Vonage::Voice::Actions::Connect, connect
    assert_equal connect.endpoint, { type: 'app', user: 'joe' }
  end

  def test_create_endpoint_with_phone
    expected = { type: 'phone', number: '123456789' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '123456789' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_phone_and_optional_param
    expected = { type: 'phone', number: '123456789', dtmfAnswer: '2p02p' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '123456789', dtmfAnswer: '2p02p' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_app
    expected = { type: 'app', user: 'joe' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_equal expected, connect.create_endpoint(connect)
  end
end