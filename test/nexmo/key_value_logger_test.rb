require_relative './test'
require 'logger'

class NexmoKeyValueLoggerTest < Nexmo::Test
  attr_accessor :io

  def setup
    self.io = StringIO.new
  end

  def test_null_logging
    logger = Nexmo::KeyValueLogger.new(nil)

    logger.info('Nexmo API response')

    assert_empty io.string
  end

  def test_includes_key_value_data
    logger = Nexmo::KeyValueLogger.new(Logger.new(io))

    logger.info('Nexmo API response', status: 200, host: 'api.nexmo.com')

    assert_includes io.string, 'status=200'
    assert_includes io.string, 'host=api.nexmo.com'
  end

  def test_ignores_nil_values
    logger = Nexmo::KeyValueLogger.new(Logger.new(io))

    logger.info('Nexmo API response', length: nil, trace_id: nil)

    refute_includes io.string, 'length='
    refute_includes io.string, 'trace_id='
  end
end
