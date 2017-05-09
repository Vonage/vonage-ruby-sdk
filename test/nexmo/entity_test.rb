require 'minitest/autorun'
require 'nexmo/entity'
require 'json'

class NexmoEntityTest < Minitest::Test
  def test_mapping_keyword_args_to_attribute_names
    value = 'xxxx-xxxx'

    entity = Nexmo::Entity.new(id: value)

    assert_equal entity.id, value
  end

  def test_mapping_string_keys_to_attribute_names
    value = '2015-03-21 11:50:56'

    entity = Nexmo::Entity.new
    entity['date_submitted'] = value

    assert_equal entity.date_submitted, value
  end

  def test_mapping_hyphenated_string_keys_to_underscored_attribute_names
    value = 'DELIVRD'

    entity = Nexmo::Entity.new
    entity['final-status'] = value

    assert_equal entity.final_status, value
  end

  def test_mapping_camelcase_string_keys_to_underscored_attribute_names
    value = 'United Kingdom'

    entity = Nexmo::Entity.new
    entity['countryDisplayName'] = value

    assert_equal entity.country_display_name, value
  end

  def test_json_object_class
    entity = JSON.parse('{"value":100.00,"autoReload":false}', object_class: Nexmo::Entity)

    assert_instance_of Nexmo::Entity, entity
    assert_equal entity.value, 100
    assert_equal entity.auto_reload, false
  end

  def test_equal_to_other_entity_objects_with_same_attributes
    entity1 = Nexmo::Entity.new(key: 'value')
    entity2 = Nexmo::Entity.new(key: 'value')

    refute_equal entity1.object_id, entity2.object_id
    assert_equal entity1, entity2
  end

  def test_not_equal_to_other_objects
    entity = Nexmo::Entity.new

    refute_equal entity, Object.new
  end

  def test_to_h_method_returns_attributes_hash
    value = 'xxxx-xxxx'

    entity = Nexmo::Entity.new
    entity[:id] = value

    assert_equal entity.to_h, {id: value}
  end
end
