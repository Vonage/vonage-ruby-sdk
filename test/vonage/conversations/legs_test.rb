# typed: false
require_relative '../test'

class Vonage::Conversations::LegsTest < Vonage::Test
  def legs
    Vonage::Conversations::Legs.new(config)
  end

  def leg_id
    'xxxxxx'
  end

  def legs_uri
    'https://api.nexmo.com/beta/legs'
  end

  def leg_uri
    "https://api.nexmo.com/beta/legs/#{leg_id}"
  end

  def test_list_method
    stub_request(:get, legs_uri).with(request).to_return(response)

    response = legs.list

    response.each{|resp| assert_kind_of Vonage::Response, resp }
  end

  def test_delete_method
    stub_request(:delete, leg_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, legs.delete(leg_id)
  end
end
