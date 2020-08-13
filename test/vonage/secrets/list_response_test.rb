# typed: false
require_relative '../test'

class Vonage::Secrets::ListResponseTest < Vonage::Test
  def secret_id
    'secret-1'
  end

  def test_each_method
    entity = Vonage::Entity.new({
      id: secret_id
    })

    list_entity = Vonage::Entity.new({
      _embedded: Vonage::Entity.new({
        secrets: [
          entity
        ]
      })
    })

    response = Vonage::Secrets::ListResponse.new(list_entity)

    enumerator = response.each

    assert_kind_of Enumerator, enumerator
    assert_equal [entity], enumerator.to_a
  end
end
