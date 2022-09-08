# typed: false

class Vonage::Voice::Actions::PayTest < Vonage::Test
  def test_pay_initialize
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99)

    assert_kind_of Vonage::Voice::Actions::Pay, pay
    assert_equal 9.99, pay.amount
  end

  def test_create_pay
    expected = [{ action: 'pay', amount: 9.99 }]
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99)

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_create_pay_with_optional_params
    expected = [{ action: 'pay', amount: 9.99, currency: "eur" }]
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99, currency: "eur")

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_create_pay_with_prompts_voice_settings
    expected = [{ action: 'pay', amount: 9.99, voice: { language: 'en-GB', style: 9 } }]
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99, voice: { language: 'en-GB', style: 9 })

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_create_pay_with_language_no_style
    expected = [{ action: 'pay', amount: 9.99, voice: { language: 'en-GB' } }]
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99, voice: { language: 'en-GB' })

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_create_pay_with_style_no_language
    expected = [{ action: 'pay', amount: 9.99, voice: { style: 9 } }]
    pay = Vonage::Voice::Actions::Pay.new(amount: 9.99, voice: { style: 9 })

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_create_pay_with_prompts_text_settings
    expected = [{
      action: 'pay',
      amount: 9.99,
      prompts: [{
        type: 'ExpirationDate',
        text: 'Please enter expiration date',
        errors: {
          InvalidExpirationDate: {
            text: 'Invalid expiration date. Please try again'
          }
        }
      }]
    }]
    pay = Vonage::Voice::Actions::Pay.new(
      amount: 9.99,
      prompts: [{
        type: 'ExpirationDate',
        text: 'Please enter expiration date',
        errors: {
          InvalidExpirationDate: {
            text: 'Invalid expiration date. Please try again'
          }
        }
      }]
    )

    assert_equal expected, pay.create_pay!(pay)
  end

  def test_pay_with_invalid_amount_value_zero
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 0.00) }

    assert_match "Invalid 'amount' value, must be greater than 0", exception.message
  end

  def test_pay_with_invalid_amount_value_non_decimal
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 1) }

    assert_match "Invalid 'amount' value, must be a float", exception.message
  end

  def test_pay_with_invalid_event_url_structure
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 9.99, eventUrl: "https://example.com/pay") }

    assert_match "Expected 'eventUrl' parameter to be an Array containing a single string item", exception.message
  end

  def test_pay_with_invalid_event_url_value
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 9.99, eventUrl: ["example.com/pay"]) }

    assert_match "Invalid 'eventUrl' value, must be a valid URL", exception.message
  end

  def test_create_pay_with_invalid_voice_structure
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 9.99, voice: 'en-GB') }

    assert_match "Expected 'voice' value to be a Hash", exception.message
  end

  def test_create_pay_with_invalid_style_value
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(amount: 9.99, voice: { language: 'en-GB', style: 'baritone' }) }

    assert_match "Expected 'style' value to be an Integer", exception.message
  end

  def test_create_pay_with_prompts_type_missing
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(
      amount: 9.99,
      prompts: [{
        text: 'Please enter expiration date',
        errors: {
          InvalidExpirationDate: {
            text: 'Invalid expiration date. Please try again'
          }
        }
      }]
    )}

    assert_match "Invalid 'prompt', 'type' is required", exception.message
  end

  def test_create_pay_with_prompts_text_missing
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(
      amount: 9.99,
      prompts: [{
        type: 'ExpirationDate',
        errors: {
          InvalidExpirationDate: {
            text: 'Invalid expiration date. Please try again'
          }
        }
      }]
    )}

    assert_match "Invalid 'prompt', 'text' is required", exception.message
  end

  def test_create_pay_with_prompts_errors_missing
    exception = assert_raises { Vonage::Voice::Actions::Pay.new(
      amount: 9.99,
      prompts: [{
        type: 'ExpirationDate',
        text: 'Please enter expiration date'
      }]
    )}

    assert_match "Invalid 'prompt', 'errors' is required", exception.message
  end
end
