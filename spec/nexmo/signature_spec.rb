require 'minitest/autorun'
require 'nexmo'

describe 'Nexmo::Signature' do
  let(:secret) { 'secret' }

  describe 'check method' do
    it 'returns true if the given params has the correct sig value' do
      params = {'a' => '1', 'b' => '2', 'timestamp' => '1461605396', 'sig' => '6af838ef94998832dbfc29020b564830'}

      Nexmo::Signature.check(params, secret).must_equal(true)
    end

    it 'returns false otherwise' do
      params = {'a' => '1', 'b' => '2', 'timestamp' => '1461605396', 'sig' => 'xxx'}

      Nexmo::Signature.check(params, secret).must_equal(false)
    end
  end
end
