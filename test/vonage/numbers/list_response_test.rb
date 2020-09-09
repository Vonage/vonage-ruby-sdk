# typed: false
require_relative '../test'

class Vonage::Numbers::ListResponseTest < Vonage::Test
  def test_each_method
    entity = Vonage::Entity.new({
      msisdn: msisdn
    })

    list_entity = Vonage::Entity.new({
      numbers: [
        entity
      ]
    })

    response = Vonage::Numbers::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
