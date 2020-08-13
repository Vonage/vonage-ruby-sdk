# typed: false
require_relative '../test'

class Vonage::Voice::ListResponseTest < Vonage::Test
  def test_each_method
    entity = Vonage::Entity.new({
      id: call_id
    })

    list_entity = Vonage::Entity.new({
      _embedded: Vonage::Entity.new({
        calls: [
          entity
        ]
      })
    })

    response = Vonage::Voice::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
