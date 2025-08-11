# typed: false
require_relative './test'

class Vonage::ErrorsTest < Minitest::Test
  Errors = Vonage.const_get(:Errors)

  def response(code, body = nil)
    result = Net::HTTPResponse::CODE_TO_OBJ[code.to_s].new(nil, code.to_s, nil)
    result.instance_variable_set(:@read, true)
    result.body = body
    result
  end

  def json_response(code, body)
    response(code).tap do |response|
      response['Content-Type'] = 'application/json;charset=UTF-8'
      response.instance_variable_set(:@read, true)
      response.body = body
    end
  end

  def test_parse_with_401_response
    error = Errors.parse(response(401))

    assert_kind_of Vonage::AuthenticationError, error
    assert_kind_of Vonage::APIError, error
    assert_kind_of Net::HTTPUnauthorized, error.http_response
    assert_equal "401", error.http_response_code
    assert_kind_of Hash, error.http_response_headers
    assert_kind_of Hash, error.http_response_body
  end

  def test_parse_with_4xx_response
    error = Errors.parse(response(400))

    assert_kind_of Vonage::ClientError, error
    assert_kind_of Vonage::APIError, error
    assert_kind_of Net::HTTPClientError, error.http_response
    assert_equal "400", error.http_response_code
    assert_kind_of Hash, error.http_response_headers
    assert_kind_of Hash, error.http_response_body
  end

  def test_parse_with_422_non_json_response
    error = Errors.parse(response(422, "random error message"))

    assert_kind_of Vonage::ClientError, error
    assert_kind_of Vonage::APIError, error
    assert_kind_of Net::HTTPClientError, error.http_response
    assert_equal "422", error.http_response_code
    assert_equal "random error message", error.message
    assert_kind_of Hash, error.http_response_headers
    assert_kind_of Hash, error.http_response_body
  end

  def test_parse_with_5xx_response
    error = Errors.parse(response(500))

    assert_kind_of Vonage::ServerError, error
    assert_kind_of Vonage::APIError, error
    assert_kind_of Net::HTTPInternalServerError, error.http_response
    assert_equal "500", error.http_response_code
    assert_kind_of Hash, error.http_response_headers
    assert_kind_of Hash, error.http_response_body
  end

  def test_parse_with_other_response
    error = Errors.parse(response(101))

    assert_kind_of Vonage::APIError, error
    assert_kind_of Net::HTTPInformation, error.http_response
    assert_equal "101", error.http_response_code
    assert_kind_of Hash, error.http_response_headers
    assert_kind_of Hash, error.http_response_body
  end

  def test_parse_with_problem_response
    error_response = json_response 403, <<-EOS
      {
        "type": "https://example.com/Error#out-of-credit",
        "title": "You do not have enough credit",
        "detail": "Your current balance is 30, but that costs 50.",
        "instance": "<trace_id>"
      }
    EOS

    error = Errors.parse(error_response)

    assert_includes error.message, 'You do not have enough credit.'
    assert_includes error.message, 'Your current balance is 30, but that costs 50.'
    assert_includes error.message, 'See https://example.com/Error#out-of-credit for more info,'
    assert_includes error.message, 'or email support@vonage.com if you have any questions.'
    assert_equal error.http_response_body['type'], "https://example.com/Error#out-of-credit"
    assert_equal error.http_response_body['title'], "You do not have enough credit"
    assert_equal error.http_response_body['detail'], "Your current balance is 30, but that costs 50."
    assert_equal error.http_response_body['instance'], "<trace_id>"
  end

  def test_parse_with_invalid_parameters_response
    error_response = json_response 400, <<-EOS
      {
        "type": "BAD_REQUEST",
        "error_title": "Bad Request",
        "invalid_parameters": {"event_url": "Is required."}
      }
    EOS

    error = Errors.parse(error_response)

    assert_includes error.message, 'Bad Request'
    assert_equal error.http_response_body['type'], "BAD_REQUEST"
    assert_equal error.http_response_body['error_title'], "Bad Request"
    assert_equal error.http_response_body['invalid_parameters']['event_url'], "Is required."
  end

  def test_parse_with_code_and_description
    error_response = json_response 404, <<-EOS
      {
        "code": "http:error:not-found",
        "description": "Endpoint does not exist, or you do not have access."
      }
    EOS

    error = Errors.parse(error_response)

    assert_includes error.message, 'Endpoint does not exist, or you do not have access'
    assert_equal error.http_response_body['code'], "http:error:not-found"
    assert_equal error.http_response_body['description'], "Endpoint does not exist, or you do not have access."
  end

  def test_parse_with_error_label
    error_response = json_response 400, <<-EOS
      {
        "error-code": "420",
        "error-code-label": "Numbers from this country can be requested from the Dashboard (https://dashboard.nexmo.com/buy-numbers) as they require a valid local address to be provided before being purchased."
      }
    EOS

    error = Errors.parse(error_response)

    assert_includes error.message, 'Numbers from this country can be requested from the Dashboard'
    assert_equal error.http_response_body['error-code'], "420"
    assert_equal error.http_response_body['error-code-label'], "Numbers from this country can be requested from the Dashboard (https://dashboard.nexmo.com/buy-numbers) as they require a valid local address to be provided before being purchased."
  end
end
