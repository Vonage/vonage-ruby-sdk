# typed: false


class Vonage::Voice::Actions::StreamTest < Vonage::Test
  def test_stream_initialize
    stream = Vonage::Voice::Actions::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ])

    assert_kind_of Vonage::Voice::Actions::Stream, stream
    assert_equal stream.streamUrl, [ 'https://example.com/example.mp3' ]
  end

  def test_create_stream
    expected = [{ action: 'stream', streamUrl: [ 'https://example.com/example.mp3' ] }]
    stream = Vonage::Voice::Actions::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ])

    assert_equal expected, stream.create_stream!(stream)
  end

  def test_create_stream_with_optional_params
    expected = [
      {
        action: 'stream',
        streamUrl: [
          'https://example.com/example.mp3'
        ],
        level: 0.5,
        bargeIn: true,
        loop: 2,
        eventOnCompletion: true,
        eventUrl: [
          'https://example.com/event'
        ],
        eventMethod: 'GET'
      }
    ]

    stream = Vonage::Voice::Actions::Stream.new(
      streamUrl: [
          'https://example.com/example.mp3'
        ],
        level: 0.5,
        bargeIn: true,
        loop: 2,
        eventOnCompletion: true,
        eventUrl: [
          'https://example.com/event'
        ],
        eventMethod: 'GET'
    )

    assert_equal expected, stream.create_stream!(stream)
  end

  def test_stream_with_invalid_stream_url_type
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: 'https://example.com/example.mp3' }) }

    assert_match "Expected 'streamUrl' parameter to be an Array containing a single string item", exception.message
  end

  def test_stream_with_invalid_stream_url
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: ['invalid'] }) }

    assert_match "Invalid 'streamUrl' value, must be a valid URL", exception.message 
  end

  def test_stream_with_invalid_level_integer
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], level: -2 }) }

    assert_match "Expected 'level' value to be a number between -1 and 1", exception.message 
  end

  def test_stream_with_invalid_level_float
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], level: -2.3 }) }

    assert_match "Expected 'level' value to be a number between -1 and 1", exception.message 
  end

  def test_stream_with_invalid_barge_in_value
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], bargeIn: 'yes' }) }

    assert_match "Expected 'bargeIn' value to be a Boolean", exception.message
  end

  def test_stream_with_invalid_loop_value
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], loop: -1 }) }

    assert_match "Expected 'loop' value to be either 0 or a positive integer", exception.message
  end

  def test_stream_with_invalid_event_on_completion_value
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], eventOnCompletion: 'true' }) }

    assert_match "Expected 'eventOnCompletion' value to be a Boolean", exception.message
  end

  def test_stream_with_invalid_event_url_type
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], eventUrl: 'https://example.com/event' }) }

    assert_match "Expected 'eventUrl' parameter to be an Array containing a single string item", exception.message
  end

  def test_stream_with_invalid_event_url
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], eventUrl: ['foo.bar'] }) }

    assert_match "Invalid 'eventUrl' value, array must contain a valid URL", exception.message
  end

  def test_stream_with_invalid_event_method
    exception = assert_raises { Vonage::Voice::Actions::Stream.new({ streamUrl: [ 'https://example.com/example.mp3' ], eventMethod: 'PATCH' }) }

    assert_match "Invalid 'eventMethod' value. must be either: 'GET' or 'POST'", exception.message
  end
end