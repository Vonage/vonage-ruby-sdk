require_relative './test'

class NexmoProblemTest < Minitest::Test
  Problem = Nexmo.const_get(:Problem)

  PROBLEM = <<-EOS
    {
      "type": "https://example.com/Error#out-of-credit",
      "title": "You do not have enough credit",
      "detail": "Your current balance is 30, but that costs 50.",
      "instance": "<trace_id>"
    }
  EOS

  def test_parse
    message = Problem.parse(PROBLEM)

    assert_includes message, 'You do not have enough credit.'
    assert_includes message, 'Your current balance is 30, but that costs 50.'
    assert_includes message, 'See https://example.com/Error#out-of-credit for more info,'
    assert_includes message, 'or email support@nexmo.com if you have any questions.'
  end
end
