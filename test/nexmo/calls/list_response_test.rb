require_relative '../test'

class Nexmo::Calls::ListResponseTest < Nexmo::Test
  def test_each_method
    entity = Nexmo::Entity.new({
      id: call_id
    })

    list_entity = Nexmo::Entity.new({
      _embedded: Nexmo::Entity.new({
        calls: [
          entity
        ]
      })
    })

    response = Nexmo::Calls::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
