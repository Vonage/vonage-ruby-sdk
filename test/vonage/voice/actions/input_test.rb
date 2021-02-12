# typed: false


class Vonage::Voice::Actions::InputTest < Vonage::Test
  def test_input_initialize
    input = Vonage::Voice::Actions::Input.new(type: [ 'dtmf' ])

    assert_kind_of Vonage::Voice::Actions::Input, input
    assert_equal input.type, [ 'dtmf' ]
  end

  def test_create_input
    expected = [{ action: 'input', type: [ 'dtmf' ] }]
    input = Vonage::Voice::Actions::Input.new(type: [ 'dtmf' ])

    assert_equal expected, input.create_input!(input)
  end

  def test_create_input_with_optional_params
    expected = [{ action: 'input', type: [ 'dtmf' ], dtmf: { maxDigits: 1 } }]
    input = Vonage::Voice::Actions::Input.new(type: [ 'dtmf' ], dtmf: { maxDigits: 1 })

    assert_equal expected, input.create_input!(input)
  end
end