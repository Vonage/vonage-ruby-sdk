# typed: false
require_relative '../../test'
require_relative '../../../../lib/vonage/voice/builders/ncco'

class Vonage::Voice::Builders::NccoTest < Vonage::Test
  def ncco
    Vonage::Voice::Builders::Ncco
  end

  def test_ncco_with_valid_action
    action = ncco.connect(endpoint: { type: 'phone', number: '4472223333' })

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"4472223333"}]}]
  end

  def test_ncco_with_valid_action_and_optional_parameters
    action = ncco.connect(endpoint: { type: 'phone', number: '4472223333' }, from: '4472223333')

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"4472223333"}], :from=>'4472223333'}]
  end

  def test_ncco_with_invalid_action
    exception = assert_raises { ncco.gotowarp }
    
    assert_match "NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.", exception.message
  end
end

class Vonage::Voice::Builders::ConnectTest < Vonage::Test
  def test_connect_initialize
    connect = Vonage::Voice::Builders::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_kind_of Vonage::Voice::Builders::Connect, connect
    assert_equal connect.endpoint, { type: 'app', user: 'joe' }
  end

  def test_create_endpoint_with_phone
    expected = { type: 'phone', number: '123456789' }
    connect = Vonage::Voice::Builders::Connect.new(endpoint: { type: 'phone', number: '123456789' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_phone_and_optional_param
    expected = { type: 'phone', number: '123456789', dtmfAnswer: '2p02p' }
    connect = Vonage::Voice::Builders::Connect.new(endpoint: { type: 'phone', number: '123456789', dtmfAnswer: '2p02p' })

    assert_equal expected, connect.create_endpoint(connect)
  end

  def test_create_endpoint_with_app
    expected = { type: 'app', user: 'joe' }
    connect = Vonage::Voice::Builders::Connect.new(endpoint: { type: 'app', user: 'joe' })

    assert_equal expected, connect.create_endpoint(connect)
  end
end

class Vonage::Voice::Builders::ConversationTest < Vonage::Test
  def test_conversation_initialize
    conversation = Vonage::Voice::Builders::Conversation.new(name: 'test123')

    assert_kind_of Vonage::Voice::Builders::Conversation, conversation
    assert_equal conversation.name, 'test123'
  end

  def test_create_conversation
    expected = [{ action: 'conversation', name: 'test123' }]
    conversation = Vonage::Voice::Builders::Conversation.new(name: 'test123')

    assert_equal expected, conversation.create_conversation!(conversation)
  end

  def test_create_conversation_with_optional_params
    expected = [{ action: 'conversation', name: 'test123', startOnEnter: false }]
    conversation = Vonage::Voice::Builders::Conversation.new(name: 'test123', startOnEnter: false)

    assert_equal expected, conversation.create_conversation!(conversation)
  end
end

class Vonage::Voice::Builders::InputTest < Vonage::Test
  def test_input_initialize
    input = Vonage::Voice::Builders::Input.new(type: [ 'dtmf' ])

    assert_kind_of Vonage::Voice::Builders::Input, input
    assert_equal input.type, [ 'dtmf' ]
  end

  def test_create_input
    expected = [{ action: 'input', type: [ 'dtmf' ] }]
    input = Vonage::Voice::Builders::Input.new(type: [ 'dtmf' ])

    assert_equal expected, input.create_input!(input)
  end

  def test_create_input_with_optional_params
    expected = [{ action: 'input', type: [ 'dtmf' ], dtmf: { maxDigits: 1 } }]
    input = Vonage::Voice::Builders::Input.new(type: [ 'dtmf' ], dtmf: { maxDigits: 1 })

    assert_equal expected, input.create_input!(input)
  end
end

class Vonage::Voice::Builders::NotifyTest < Vonage::Test
  def test_notify_initialize
    notify = Vonage::Voice::Builders::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ])

    assert_kind_of Vonage::Voice::Builders::Notify, notify
    assert_equal notify.eventUrl, ['https://example.com']
  end

  def test_create_notify
    expected = [{ action: 'notify', payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ] }]
    notify = Vonage::Voice::Builders::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ])

    assert_equal expected, notify.create_notify!(notify)
  end

  def test_create_notify_with_optional_params
    expected = [{ action: 'notify', payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ], eventMethod: 'POST' }]
    notify = Vonage::Voice::Builders::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ], eventMethod: 'POST')

    assert_equal expected, notify.create_notify!(notify)
  end
end

class Vonage::Voice::Builders::RecordTest < Vonage::Test
  def test_record_initialize
    record = Vonage::Voice::Builders::Record.new

    assert_kind_of Vonage::Voice::Builders::Record, record
  end

  def test_create_record
    expected = [{ action: 'record' }]
    record = Vonage::Voice::Builders::Record.new

    assert_equal expected, record.create_record!(record)
  end

  def test_create_record_with_optional_params
    expected = [{ action: 'record', format: 'mp3' }]
    record = Vonage::Voice::Builders::Record.new(format: 'mp3')

    assert_equal expected, record.create_record!(record)
  end
end

class Vonage::Voice::Builders::StreamTest < Vonage::Test
  def test_stream_initialize
    stream = Vonage::Voice::Builders::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ])

    assert_kind_of Vonage::Voice::Builders::Stream, stream
    assert_equal stream.streamUrl, [ 'https://example.com/example.mp3' ]
  end

  def test_create_stream
    expected = [{ action: 'stream', streamUrl: [ 'https://example.com/example.mp3' ] }]
    stream = Vonage::Voice::Builders::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ])

    assert_equal expected, stream.create_stream!(stream)
  end

  def test_create_stream_with_optional_params
    expected = [{ action: 'stream', streamUrl: [ 'https://example.com/example.mp3' ], bargeIn: true }]
    stream = Vonage::Voice::Builders::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ], bargeIn: true)

    assert_equal expected, stream.create_stream!(stream)
  end
end

class Vonage::Voice::Builders::TalkTest < Vonage::Test
  def test_talk_initialize
    talk = Vonage::Voice::Builders::Talk.new(text: 'Sample Text')

    assert_kind_of Vonage::Voice::Builders::Talk, talk
    assert_equal talk.text, 'Sample Text'
  end

  def test_create_talk
    expected = [{ action: 'talk', text: 'Sample Text' }]
    talk = Vonage::Voice::Builders::Talk.new(text: 'Sample Text')

    assert_equal expected, talk.create_talk!(talk)
  end

  def test_create_talk_with_optional_params
    expected = [{ action: 'talk', text: 'Sample Text', bargeIn: true }]
    talk = Vonage::Voice::Builders::Talk.new(text: 'Sample Text', bargeIn: true)

    assert_equal expected, talk.create_talk!(talk)
  end
end