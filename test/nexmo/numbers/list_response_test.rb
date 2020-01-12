# typed: false
require_relative '../test'

class Nexmo::Numbers::ListResponseTest < Nexmo::Test
  def test_each_method
    entity = Nexmo::Entity.new({
      msisdn: msisdn
    })

    list_entity = Nexmo::Entity.new({
      numbers: [
        entity
      ]
    })

    response = Nexmo::Numbers::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
