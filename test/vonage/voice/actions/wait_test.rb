# typed: false


class Vonage::Voice::Actions::WaitTest < Vonage::Test
  def test_wait_initialize
    wait = Vonage::Voice::Actions::Wait.new

    assert_kind_of Vonage::Voice::Actions::Wait, wait
  end

  def test_create_wait
    expected = [{ action: 'wait' }]
    wait = Vonage::Voice::Actions::Wait.new

    assert_equal expected, wait.create_wait!(wait)
  end

  def test_create_wait_with_optional_params
    expected = [{ action: 'wait', timeout: 10 }]
    wait = Vonage::Voice::Actions::Wait.new(timeout: 10)

    assert_equal expected, wait.create_wait!(wait)
  end

  def test_create_wait_with_timeout_as_integer
    expected = [{ action: 'wait', timeout: 10 }]
    wait = Vonage::Voice::Actions::Wait.new(timeout: 10)

    assert_equal expected, wait.create_wait!(wait)
  end

  def test_create_wait_with_timeout_as_float
    expected = [{ action: 'wait', timeout: 10.5 }]
    wait = Vonage::Voice::Actions::Wait.new(timeout: 10.5)

    assert_equal expected, wait.create_wait!(wait)
  end

  def test_wait_with_invalid_timeout
    exception = assert_raises { Vonage::Voice::Actions::Wait.new(timeout: 'invalid') }

    assert_match "Expected 'timeout' parameter to be a number", exception.message
  end
end