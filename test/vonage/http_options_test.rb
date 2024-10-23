# typed: false
require_relative './test'

class Vonage::HTTPOptionsTest < Minitest::Test
  Options = Vonage.const_get(:HTTP).const_get(:Options)

  def read_timeout
    5
  end

  def proxy_host
    'example.com'
  end

  def proxy_port
    4567
  end

  def ca_file
    'cert.pem'
  end

  def test_invalid_option_raises_argument_error
    exception = assert_raises(ArgumentError) { Options.new(foo_timeout: 1) }

    assert_includes exception.message, ':foo_timeout is not a valid option'
  end

  def test_set_method
    http = Net::HTTP::Persistent.new

    proxy = URI::HTTP.build(host: proxy_host, port: proxy_port)

    options = Options.new(read_timeout: read_timeout, proxy: proxy, ca_file: ca_file)
    options.set(http)

    assert_equal read_timeout, http.read_timeout
    assert_equal proxy_host, http.proxy_uri.hostname
    assert_equal proxy_port, http.proxy_uri.port
    assert_equal ca_file, http.ca_file
  end
end
