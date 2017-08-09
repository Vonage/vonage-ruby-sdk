require 'minitest/autorun'
require 'nexmo'

describe 'Nexmo::Params' do
  describe 'encode method' do
    it 'returns a url encoded string containing the given params' do
      params = {'name' => 'Example App', 'type' => 'voice'}

      Nexmo::Params.encode(params).must_equal('name=Example+App&type=voice')
    end

    it 'flattens array values into multiple key value pairs' do
      params = {'ids' => %w[00A0B0C0 00A0B0C1 00A0B0C2]}

      Nexmo::Params.encode(params).must_equal('ids=00A0B0C0&ids=00A0B0C1&ids=00A0B0C2')
    end
  end
end
