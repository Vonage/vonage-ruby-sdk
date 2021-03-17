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

  def test_input_with_invalid_type_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['vulcan']) }

    assert_match "Invalid 'type' value, must be 'dtmf', 'speech' or both 'dtmf' and 'speech'", exception.message
  end

  def test_input_with_invalid_type_structure
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: 'dtmf') }
  
    assert_match "Invalid 'type', must be an Array of at least one String", exception.message
  end

  def test_input_with_dtmf_options_and_no_dtmf_in_type
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], dtmf: { submitOnHash: true }) }

    assert_match "Expected 'dtmf' to be included in 'type' parameter if 'dtmf' options specified", exception.message
  end

  def test_input_with_invalid_dtmf_timeout_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['dtmf'], dtmf: { timeOut: 12 }) }
  
    assert_match "Expected 'timeOut' to not be more than 10 seconds", exception.message    
  end

  def test_input_with_invalid_dtmf_max_digits_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['dtmf'], dtmf: { maxDigits: 23 }) }

    assert_match "Expected 'maxDigits' to not be more than 22", exception.message
  end

  def test_input_with_invalid_dtmf_submit_on_hash_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['dtmf'], dtmf: { submitOnHash: 'yes' }) }

    assert_match "Invalid 'submitOnHash' value, must be a Boolean", exception.message    
  end

  def test_input_with_speech_options_and_no_speech_in_type
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['dtmf'], speech: { endOnSilence: 9 }) }

    assert_match "Expected 'speech' to be included in 'type' parameter if 'speech' options specified", exception.message
  end

  def test_input_with_invalid_speech_uuid_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { uuid: 'abc' }) }

    assert_match "Invalid 'uuid' value, must be an Array containing a single call leg ID element", exception.message 
  end

  def test_input_with_invalid_speech_end_on_silence_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { endOnSilence: 12 }) }

    assert_match "Expected 'endOnSilence' to not be more than 10 seconds", exception.message 
  end

  def test_input_with_invalid_context_type
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { context: 'vonage' }) }

    assert_match "Expected 'context' to be an Array of strings", exception.message 
  end

  def test_input_with_invalid_speech_start_timeout_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { startTimeout: 22 }) }

    assert_match "Expected 'startTimeout' to not be more than 10 seconds", exception.message
  end

  def test_input_with_invalid_speech_max_duration_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { maxDuration: 62 }) }

    assert_match "Expected 'maxDuration' to not be more than 60 seconds", exception.message
  end

  def test_input_with_invalid_event_url_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { maxDuration: 10 }, eventUrl: 'invalid') }

    assert_match "Invalid 'eventUrl' value, must be a valid URL", exception.message
  end

  def test_input_with_invalid_event_method_value
    exception = assert_raises { Vonage::Voice::Actions::Input.new(type: ['speech'], speech: { maxDuration: 10 }, eventMethod: 'invalid') }

    assert_match "Invalid 'eventMethod' value. must be either: 'GET' or 'POST'", exception.message
  end
end