# typed: false
require_relative './test'

class Vonage::HTTPOptionsTest < Minitest::Test
  Options = Vonage.const_get(:HTTP).const_get(:Options)

  def read_timeout
    5
  end

  def proxy_address
    'localhost'
  end

  def ca_file
    'cert.pem'
  end

  def test_invalid_option_raises_argument_error
    exception = assert_raises(ArgumentError) { Options.new(foo_timeout: 1) }

    assert_includes exception.message, ':foo_timeout is not a valid option'
  end

  def test_set_method
    http = Net::HTTP.new('example.com', Net::HTTP.https_default_port, p_addr = nil)

    options = Options.new(read_timeout: read_timeout, proxy_address: proxy_address, ca_file: ca_file)
    options.set(http)

    assert_equal read_timeout, http.read_timeout
    assert_equal proxy_address, http.proxy_address
    assert_equal ca_file, http.ca_file
  end
end
