# typed: false

class Vonage::Meetings::DialInNumbersTest < Vonage::Test
  def dial_in_numbers
    Vonage::Meetings::DialInNumbers.new(config)
  end

  def dial_in_numbers_uri
    "https://" + meetings_host + "/v1/meetings/dial-in-numbers"
  end

  def list_response
    {
      headers: response_headers,
      body: '[{"key":"value"}, {"key":"value"}, {"key":"value"}]'
    }
  end

  def test_list_method
    stub_request(:get, dial_in_numbers_uri).to_return(list_response)
    dial_in_numbers_list = dial_in_numbers.list

    assert_kind_of Vonage::Meetings::DialInNumbers::ListResponse,
                   dial_in_numbers_list
    dial_in_numbers_list.each { |number| assert_kind_of Vonage::Entity, number }
  end
end
