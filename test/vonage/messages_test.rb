# typed: false
require_relative './test'

class Vonage::MessagesTest < Vonage::Test
  def messages
    Vonage::Messages.new(config)
  end

  def message_id
    '00A0B0C0'
  end

  def date
    'YYYY-MM-DD'
  end

  def test_get_method
    uri = 'https://rest.nexmo.com/search/message'

    params = {id: message_id}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, messages.get(message_id)
  end

  def test_search_method_with_ids
    uri = 'https://rest.nexmo.com/search/messages'

    id1, id2, id3 = '00A0B0C0', '00A0B0C1', '00A0B0C2'

    values = [['ids', id1], ['ids', id2], ['ids', id3], ['api_key', api_key], ['api_secret', api_secret]]

    query = WebMock::Util::QueryMapper.values_to_query(values)

    stub_request(:get, uri).with(query: query).to_return(response)

    assert_kind_of Vonage::Response, messages.search(ids: [id1, id2, id3])
  end

  def test_search_method_with_recipient_and_date
    uri = 'https://rest.nexmo.com/search/messages'

    params = {date: date, to: msisdn}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, messages.search(params)
  end

  def test_rejections_method
    uri = 'https://rest.nexmo.com/search/rejections'

    params = {date: date, to: msisdn}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, messages.rejections(params)
  end
end
