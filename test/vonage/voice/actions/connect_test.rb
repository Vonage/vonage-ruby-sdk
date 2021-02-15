# typed: false


class Vonage::Voice::Actions::ConnectTest < Vonage::Test
  def test_connect_initialize
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_kind_of Vonage::Voice::Actions::Connect, connect
    assert_equal connect.endpoint, { type: 'app', user: 'joe' }
  end

  def test_create_endpoint_with_phone
    expected = { type: 'phone', number: '12129999999' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12129999999' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_phone_and_optional_param
    expected = { type: 'phone', number: '12129999999', dtmfAnswer: '2p02p' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12129999999', dtmfAnswer: '2p02p' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_app
    expected = { type: 'app', user: 'joe' }
    connect = Vonage::Voice::Actions::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_verify_endpoint_with_invalid_phone_number
    endpoint = { type: 'phone', number: 'abcd' }

    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: endpoint) }
    
    assert_match "Expected 'number' value to be in E.164 format", exception.message
  end

  def test_verify_with_invalid_from_number
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, from: 'abcd') }
    
    assert_match "Invalid 'from' value, must be in E.164 format", exception.message
  end

  def test_verify_with_invalid_event_type
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, eventType: 'abcd') }

    assert_match "Invalid 'eventType' value, must be 'synchronous' if defined", exception.message
  end

  def test_verify_with_invalid_limit
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, limit: '8000') }

    assert_match "Invalid 'limit' value, must be between 0 and 7200 seconds", exception.message
  end

  def test_verify_with_invalid_machine_detection
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, machineDetection: 'yes') }

    assert_match "Invalid 'machineDetection' value, must be either: 'continue' or 'hangup' if defined", exception.message
  end

  def test_verify_with_invalid_event_url
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, eventUrl: 'invalid') }

    assert_match "Invalid 'eventUrl' value, must be a valid URL", exception.message
  end

  def test_verify_with_invalid_event_method
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, eventMethod: 'invalid') }

    assert_match "Invalid 'eventMethod' value. must be either: 'GET' or 'POST'", exception.message
  end

  def test_verify_with_invalid_ringback_tone
    exception = assert_raises { Vonage::Voice::Actions::Connect.new(endpoint: { type: 'phone', number: '12122222222' }, ringbackTone: 'invalid') }

    assert_match "Invalid 'ringbackTone' value, must be a valid URL", exception.message
  end

end