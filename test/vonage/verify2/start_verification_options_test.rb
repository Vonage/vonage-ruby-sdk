# typed: false

class Vonage::Verify2::StartVerificationOptionsTest < Vonage::Test
  def options
    Vonage::Verify2::StartVerificationOptions.new
  end

  def test_locale_getter_method
    assert_nil options.locale
  end

  def test_locale_setter_method
    opts = options
    opts.locale = 'en-gb'

    assert_equal 'en-gb', opts.instance_variable_get(:@locale)
  end

  def test_channel_timeout_getter_method
    assert_nil options.channel_timeout
  end

  def test_channel_timeout_setter_method
    opts = options
    opts.channel_timeout = 90

    assert_equal 90, opts.instance_variable_get(:@channel_timeout)
  end

  def test_channel_timeout_setter_method_with_invalid_arg
    opts = options
    assert_raises ArgumentError do
      opts.channel_timeout = 0
    end
  end

  def test_client_ref_getter_method
    assert_nil options.client_ref
  end

  def test_client_ref_setter_method
    opts = options
    opts.client_ref = 'foo'

    assert_equal 'foo', opts.instance_variable_get(:@client_ref)
  end


  def test_code_length_getter_method
    assert_nil options.code_length
  end

  def test_code_length_setter_method
    opts = options
    opts.code_length = 6

    assert_equal 6, opts.instance_variable_get(:@code_length)
  end

  def test_code_length_setter_method_with_invalid_arg
    opts = options
    assert_raises ArgumentError do
      opts.code_length = 1000
    end
  end

  def test_code_getter_method
    assert_nil options.code
  end

  def test_code_setter_method
    opts = options
    opts.code = 'abc123'

    assert_equal 'abc123', opts.instance_variable_get(:@code)
  end

  def test_fraud_check_getter_method
    assert_nil options.fraud_check
  end

  def test_fraud_check_setter_method
    opts = options
    opts.fraud_check = false

    assert_equal false, opts.instance_variable_get(:@fraud_check)
  end

  def test_fraud_check_setter_method_with_invalid_arg
    opts = options
    assert_raises ArgumentError do
      opts.fraud_check = true
    end
  end

  def test_to_h_method
    opts_hash = Vonage::Verify2::StartVerificationOptions.new(
      locale: 'en-gb',
      channel_timeout: 90,
      client_ref: 'foo',
      code_length: 6
    ).to_h

    assert_kind_of Hash, opts_hash
    assert_equal 'en-gb', opts_hash[:locale]
    assert_equal 90, opts_hash[:channel_timeout]
    assert_equal 'foo', opts_hash[:client_ref]
    assert_equal 6, opts_hash[:code_length]
  end
end
