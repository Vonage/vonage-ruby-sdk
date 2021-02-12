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
end