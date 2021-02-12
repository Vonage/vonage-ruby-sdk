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
    expected = [{ action: 'stream', streamUrl: [ 'https://example.com/example.mp3' ], bargeIn: true }]
    stream = Vonage::Voice::Actions::Stream.new(streamUrl: [ 'https://example.com/example.mp3' ], bargeIn: true)

    assert_equal expected, stream.create_stream!(stream)
  end
end