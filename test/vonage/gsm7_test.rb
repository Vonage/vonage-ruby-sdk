# typed: false
require_relative './test'

class Vonage::GSM7Test < Minitest::Test
  GSM7 = Vonage.const_get(:GSM7)

  def test_encoded_method
    assert GSM7.encoded?('Hello world')
    assert GSM7.encoded?('Bonjour monde')
    assert GSM7.encoded?('Hola mundo')

    refute GSM7.encoded?("Unicode \u2713")
    refute GSM7.encoded?("مرحبا بالعالم")
    refute GSM7.encoded?("שלום עולם")
    refute GSM7.encoded?("Привет мир")
  end
end
