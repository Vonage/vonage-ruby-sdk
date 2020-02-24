# typed: false
require_relative '../test'

class Nexmo::Secrets::ListResponseTest < Nexmo::Test
  def secret_id
    'secret-1'
  end

  def test_each_method
    entity = Nexmo::Entity.new({
      id: secret_id
    })

    list_entity = Nexmo::Entity.new({
      _embedded: Nexmo::Entity.new({
        secrets: [
          entity
        ]
      })
    })

    response = Nexmo::Secrets::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
