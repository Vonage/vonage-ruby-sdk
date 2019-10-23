require_relative './test'

class NexmoErrorsTest < Minitest::Test
  Errors = Nexmo.const_get(:Errors)

  def response(code)
    Net::HTTPResponse::CODE_TO_OBJ[code.to_s].new(nil, code.to_s, nil)
  end

  def test_parse_with_401_response
    error = Errors.parse(response(401))

    assert_kind_of Nexmo::AuthenticationError, error
  end

  def test_parse_with_4xx_response
    error = Errors.parse(response(400))

    assert_kind_of Nexmo::ClientError, error
  end

  def test_parse_with_5xx_response
    error = Errors.parse(response(500))

    assert_kind_of Nexmo::ServerError, error
  end

  def test_parse_with_other_response
    error = Errors.parse(response(101))

    assert_kind_of Nexmo::Error, error
  end

  def test_parse_with_problem_response
    problem_response = response(403).tap do |response|
      response['Content-Type'] = 'application/json;charset=UTF-8'
      response.instance_variable_set(:@read, true)
      response.body = <<-EOS
        {
          "type": "https://example.com/Error#out-of-credit",
          "title": "You do not have enough credit",
          "detail": "Your current balance is 30, but that costs 50.",
          "instance": "<trace_id>"
        }
      EOS
    end

    error = Errors.parse(problem_response)

    assert_includes error.message, 'You do not have enough credit.'
    assert_includes error.message, 'Your current balance is 30, but that costs 50.'
    assert_includes error.message, 'See https://example.com/Error#out-of-credit for more info,'
    assert_includes error.message, 'or email support@nexmo.com if you have any questions.'
  end

  def test_parse_with_invalid_parameters_response
    invalid_parameters_response = response(400).tap do |response|
      response['Content-Type'] = 'application/json'
      response.instance_variable_set(:@read, true)
      response.body = <<-EOS
        {
          "type": "BAD_REQUEST",
          "error_title": "Bad Request",
          "invalid_parameters": {"event_url": "Is required."}
        }
      EOS
    end

    error = Errors.parse(invalid_parameters_response)

    assert_includes error.message, 'Bad Request'
  end

  def test_parse_with_code_and_description
    error_response = response(404).tap do |response|
      response['Content-Type'] = 'application/json'
      response.instance_variable_set(:@read, true)
      response.body = <<-EOS
        {
          "code": "http:error:not-found",
          "description": "Endpoint does not exist, or you do not have access."
        }
      EOS
    end

    error = Errors.parse(error_response)

    assert_includes error.message, 'Endpoint does not exist, or you do not have access'
  end
end
