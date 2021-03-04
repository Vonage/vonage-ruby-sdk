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
    expected = [{ action: 'talk', text: 'Sample Text', bargeIn: true }]
    talk = Vonage::Voice::Actions::Talk.new(text: 'Sample Text', bargeIn: true)

    assert_equal expected, talk.create_talk!(talk)
  end

  def test_talk_with_invalid_barge_in_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', bargeIn: 'yes' }) }

    assert_match "Expected 'bargeIn' value to be a Boolean", exception.message
  end

  def test_talk_with_invalid_loop_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', loop: 3 }) }

    assert_match "Expected 'loop' value to be either 1 or 0", exception.message
  end

  def test_talk_with_invalid_level
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', level: -2 }) }

    assert_match "Expected 'level' value to be a number between -1 and 1", exception.message 
  end

  def test_talk_with_invalid_style_value
    exception = assert_raises { Vonage::Voice::Actions::Talk.new({ text: 'Sample Text', style: 'baritone' }) }

    assert_match "Expected 'style' value to be an Integer", exception.message 
  end
end