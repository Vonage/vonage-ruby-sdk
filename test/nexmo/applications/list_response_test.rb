# typed: false
require_relative '../test'

class Nexmo::Applications::ListResponseTest < Nexmo::Test
  def test_each_method
    entity = Nexmo::Entity.new({
      id: application_id
    })

    list_entity = Nexmo::Entity.new({
      _embedded: Nexmo::Entity.new({
        applications: [
          entity
        ]
      })
    })

    response = Nexmo::Applications::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
