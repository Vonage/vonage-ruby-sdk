# typed: false
require_relative "./test"

class Vonage::NumbersTest < Vonage::Test
  def numbers
    Vonage::Numbers.new(config)
  end

  def test_list_method
    uri = "https://rest.nexmo.com/account/numbers"

    params = { size: 25, pattern: "33" }

    stub_request(:get, uri).with(query: params).to_return(numbers_response)

    response = numbers.list(params)

    response.each { |resp| assert_kind_of Vonage::Numbers::ListResponse, resp }
  end

  def test_list_method_without_args
    uri = "https://rest.nexmo.com/account/numbers"

    stub_request(:get, uri).to_return(numbers_response)

    response = numbers.list

    response.each { |resp| assert_kind_of Vonage::Numbers::ListResponse, resp }
  end

  def test_search_method
    uri = "https://rest.nexmo.com/number/search"

    params = { size: 25, country: country }

    stub_request(:get, uri).with(query: params).to_return(response)

    assert_kind_of Vonage::Numbers::ListResponse, numbers.search(params)
  end

  def test_search_method_with_auto_advance
    uri = "https://rest.nexmo.com/number/search"

    params = { country: country }

    stub_request(:get, uri).with(query: params).to_return(
      numbers_response_paginated_page_1
    )

    stub_request(:get, uri).with(query: params.merge(index: 2)).to_return(
      numbers_response_paginated_page_2
    )

    response = numbers.search(params.merge(auto_advance: true))

    assert_kind_of Vonage::Numbers::ListResponse, response
    assert_equal 14, response.numbers.length
  end

  def test_search_method_with_auto_advance_with_index_offset_by_one_page
    uri = "https://rest.nexmo.com/number/search"

    params = { country: country }

    stub_request(:get, uri).with(query: params.merge(index: 2)).to_return(
      numbers_response_paginated_page_2
    )

    response = numbers.search(params.merge(auto_advance: true, index: 2))

    assert_kind_of Vonage::Numbers::ListResponse, response
    assert_equal 4, response.numbers.length
  end

  def test_buy_method
    uri = "https://rest.nexmo.com/number/buy"

    params = { country: country, msisdn: msisdn }

    stub_request(:post, uri).with(headers: headers, body: params).to_return(
      response
    )

    assert_kind_of Vonage::Numbers::Response, numbers.buy(params)
  end

  def test_cancel_method
    uri = "https://rest.nexmo.com/number/cancel"

    params = { country: country, msisdn: msisdn }

    stub_request(:post, uri).with(headers: headers, body: params).to_return(
      response
    )

    assert_kind_of Vonage::Numbers::Response, numbers.cancel(params)
  end

  def test_update_method
    uri = "https://rest.nexmo.com/number/update"

    mo_http_url = "https://example.com/callback"

    params = {
      "country" => country,
      "msisdn" => msisdn,
      "moHttpUrl" => mo_http_url
    }

    stub_request(:post, uri).with(headers: headers, body: params).to_return(
      response
    )

    assert_kind_of Vonage::Numbers::Response,
                   numbers.update(
                     country: country,
                     msisdn: msisdn,
                     mo_http_url: mo_http_url
                   )
  end
end
