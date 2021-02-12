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
end