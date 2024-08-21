# typed: false


class Vonage::Voice::Actions::TalkTest < Vonage::Test
  def test_talk_initialize
    talk = Vonage::Voice::Actions::Talk.new(text: 'Sample Text')

    assert_kind_of Vonage::Voice::Actions::Talk, talk
    assert_equal talk.text, 'Sample Text'
  end

  def test_create_talk
    expected = [{ action: 'talk', text: 'Sample Text' }]
    talk = Vonage::Voice::Actions::Talk.new(text: 'Sample Text')

    assert_equal expected, talk.create_talk!(talk)
  end

  def test_create_talk_with_optional_params
    expected = [
      {
        action: 'talk',
        text: 'Sample Text',
        bargeIn: true,
        loop: 3,
        level: 0.5,
        language: 'en-GB',
        style: 1,
        premium: true,
        eventOnCompletion: true,
        eventUrl: [
          'https://example.com/event'
        ],
        eventMethod: 'GET'
      }
    ]

    talk = Vonage::Voice::Actions::Talk.new(
      text: 'Sample Text',
      bargeIn: true,
      loop: 3,
      level: 0.5,
      language: 'en-GB',
      style: 1,
      premium: true,
      eventOnCompletion: true,
      eventUrl: [
        'https://example.com/event'
      ],
      eventMethod: 'GET'
    )

    assert_equal expected, talk.create_talk!(talk)
  end

  def test_talk_with_invalid_barge_in_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', bargeIn: 'yes' }) }

    assert_match "Expected 'bargeIn' value to be a Boolean", exception.message
  end

  def test_talk_with_invalid_loop_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', loop: -1 }) }

    assert_match "Expected 'loop' value to be either 0 or a positive integer", exception.message
  end

  def test_talk_with_invalid_level
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', level: -2 }) }

    assert_match "Expected 'level' value to be a number between -1 and 1", exception.message
  end

  def test_talk_with_invalid_style_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', style: 'baritone' }) }

    assert_match "Expected 'style' value to be an Integer", exception.message
  end

  def test_talk_with_invalid_premium_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', premium: 'foo' }) }

    assert_match "Expected 'premium' value to be a Boolean", exception.message
  end

  def test_talk_with_invalid_event_on_completion_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', eventOnCompletion: 'true' }) }

    assert_match "Expected 'eventOnCompletion' value to be a Boolean", exception.message
  end

  def test_talk_with_invalid_event_url_type
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', eventUrl: 'https://example.com/example.mp3' }) }

    assert_match "Expected 'eventUrl' parameter to be an Array containing a single string item", exception.message
  end

  def test_talk_with_invalid_event_url
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', eventUrl: ['foo.bar'] }) }

    assert_match "Invalid 'eventUrl' value, array must contain a valid URL", exception.message
  end

  def test_talk_with_invalid_event_method
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', eventMethod: 'PATCH' }) }

    assert_match "Invalid 'eventMethod' value. must be either: 'GET' or 'POST'", exception.message
  end
end
