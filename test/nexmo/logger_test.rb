require_relative './test'

class NexmoLoggerTest < Nexmo::Test
  Logger = Nexmo.const_get(:Logger)

  def setup
    @io = StringIO.new
  end

  attr_reader :io

  def uri
    URI('https://api.nexmo.com/v1/calls')
  end

  def test_with_null_logger
    logger = Logger.new(::Logger.new(nil))

    logger.info('Nexmo API response')

    assert_empty io.string
  end

  def test_log_request_info
    logger = Logger.new(::Logger.new(io))

    request = Net::HTTP::Get.new(uri)

    logger.log_request_info(request)

    assert_includes io.string, 'Nexmo API request'
    assert_includes io.string, 'method=GET'
    assert_includes io.string, 'path=/v1/calls'
  end

  def test_log_response_info
    logger = Logger.new(::Logger.new(io))

    response = Net::HTTPResponse.new(nil, 200, 'OK')
    response['Content-Type'] = 'application/json'
    response['Content-Length'] = 123
    response['X-Nexmo-Trace-ID'] = 'nexmo-trace-id'

    logger.log_response_info(response, uri.host)

    assert_includes io.string, 'Nexmo API response'
    assert_includes io.string, 'host=api.nexmo.com'
    assert_includes io.string, 'status=200'
    assert_includes io.string, 'type=application/json'
    assert_includes io.string, 'length=123'
    assert_includes io.string, 'trace_id=nexmo-trace-id'
  end

  def test_log_response_info_with_nil_values
    logger = Logger.new(::Logger.new(io))

    response = Net::HTTPResponse.new(nil, 200, 'OK')

    logger.log_response_info(response, uri.host)

    refute_includes io.string, 'length='
    refute_includes io.string, 'trace_id='
  end
end
