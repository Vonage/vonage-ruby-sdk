require_relative './test'

class NexmoErrorTest < Minitest::Test
  def response(code)
    Net::HTTPResponse::CODE_TO_OBJ[code.to_s].new(nil, code.to_s, nil)
  end

  def test_parse_with_401_response
    error = Nexmo::Error.parse(response(401))

    assert_kind_of Nexmo::AuthenticationError, error
  end

  def test_parse_with_4xx_response
    error = Nexmo::Error.parse(response(400))

    assert_kind_of Nexmo::ClientError, error
  end

  def test_parse_with_5xx_response
    error = Nexmo::Error.parse(response(500))

    assert_kind_of Nexmo::ServerError, error
  end

  def test_parse_with_other_response
    error = Nexmo::Error.parse(response(101))

    assert_kind_of Nexmo::Error, error
  end

  def test_parse_with_problem_response
    problem_response = response(403).tap do |response|
      response['Content-Type'] = 'application/problem+json'
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

    error = Nexmo::Error.parse(problem_response)

    assert_includes error.message, 'You do not have enough credit'
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

    error = Nexmo::Error.parse(invalid_parameters_response)

    assert_includes error.message, 'Bad Request'
  end
end
