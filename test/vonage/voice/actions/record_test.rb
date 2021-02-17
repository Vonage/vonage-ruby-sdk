# typed: false


class Vonage::Voice::Actions::RecordTest < Vonage::Test
  def test_record_initialize
    record = Vonage::Voice::Actions::Record.new

    assert_kind_of Vonage::Voice::Actions::Record, record
  end

  def test_create_record
    expected = [{ action: 'record' }]
    record = Vonage::Voice::Actions::Record.new

    assert_equal expected, record.create_record!(record)
  end

  def test_create_record_with_optional_params
    expected = [{ action: 'record', format: 'mp3' }]
    record = Vonage::Voice::Actions::Record.new(format: 'mp3')

    assert_equal expected, record.create_record!(record)
  end

  def test_record_with_invalid_format
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', format: 'mov' }) }

    assert_match "Invalid format, must be one of: 'mp3', 'wav', 'ogg'", exception.message
  end

  def test_record_with_invalid_split
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', split: 'yes' }) }

    assert_match "Expected 'split' value to be 'conversation' if defined", exception.message
  end

  def test_record_with_invalid_channels_no_split
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', channels: 18 }) }

    assert_match "The 'split' parameter must be defined to 'conversation' to also define 'channels'", exception.message
  end

  def test_record_with_invalid_channels
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', channels: 33, split: 'conversation' }) }

    assert_match "Expected 'split' parameter to be equal to or less than 32", exception.message
  end

  def test_record_with_invalid_end_on_silence
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', endOnSilence: 2 }) }

    assert_match "Expected 'endOnSilence' value to be between 3 and 10", exception.message
  end

  def test_record_with_invalid_end_on_key
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', endOnKey: '10' }) }

    assert_match "Expected 'endOnKey' value to be a one of the following: a single digit between 1-9, '*' or '#'", exception.message
  end

  def test_record_with_asterisk_end_on_key_value
    expected = [{ action: 'record', endOnKey: '*' }]
    record = Vonage::Voice::Actions::Record.new(endOnKey: '*')

    assert_equal expected, record.create_record!(record)
  end

  def test_record_with_single_numeric_digit_end_on_key_value
    expected = [{ action: 'record', endOnKey: '2' }]
    record = Vonage::Voice::Actions::Record.new(endOnKey: '2')

    assert_equal expected, record.create_record!(record)
  end

  def test_record_with_invalid_time_out_value
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', timeOut: 7201 }) }

    assert_match "Expected 'timeOut' value to be between 3 and 7200 seconds", exception.message
  end

  def test_record_with_invalid_beep_start_value
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', beepStart: 'yes' }) }

    assert_match "Expected 'beepStart' value to be a Boolean", exception.message
  end

  def test_record_with_invalid_event_url_value
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', eventUrl: 'invalid'}) }

    assert_match "Invalid 'eventUrl' value, must be a valid URL", exception.message
  end

  def test_record_with_invalid_event_method_value
    exception = assert_raises { Vonage::Voice::Actions::Record.new({ action: 'record', eventMethod: 'invalid'}) }

    assert_match "Invalid 'eventMethod' value. must be either: 'GET' or 'POST'", exception.message
  end
end