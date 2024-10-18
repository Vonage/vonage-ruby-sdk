# typed: false

class Vonage::Verify2::TemplatesTest < Vonage::Test
  def templates
    Vonage::Verify2::Templates.new(config)
  end

  def template_id
    '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9'
  end

  def templates_uri
    'https://api.nexmo.com/v2/verify/templates'
  end

  def template_uri
    'https://api.nexmo.com/v2/verify/templates/' + template_id
  end

  def templates_list_response
    { body: '{"_embedded": {"templates":[{"key":"value"}]}}', headers: response_headers }
  end

  def test_list_method
    stub_request(:get, templates_uri).to_return(templates_list_response)

    templates_list = templates.list

    assert_kind_of Vonage::Verify2::Templates::ListResponse, templates_list
    templates_list.each { |template| assert_kind_of Vonage::Entity, template }
  end

  def test_list_method_with_optional_params
    stub_request(:get, templates_uri + '?page_size=10&page=2').to_return(templates_list_response)

    templates_list = templates.list(page_size: 10, page: 2)

    assert_kind_of Vonage::Verify2::Templates::ListResponse, templates_list
    templates_list.each { |template| assert_kind_of Vonage::Entity, template }
  end

  def test_info_method
    stub_request(:get, template_uri).to_return(response)

    assert_kind_of Vonage::Response, templates.info(template_id: template_id)
  end

  def test_info_method_without_template_id
    assert_raises(ArgumentError) { templates.info }
  end

  def test_create_method
    stub_request(:post, templates_uri).with(body: { name: 'My Template' }).to_return(response)

    assert_kind_of Vonage::Response, templates.create(name: 'My Template')
  end

  def test_create_method_without_name
    assert_raises(ArgumentError) { templates.create }
  end

  def test_update_method
    stub_request(:patch, template_uri).with(body: { name: 'My Updated Template', is_default: false }).to_return(response)

    assert_kind_of Vonage::Response, templates.update(template_id: template_id, name: 'My Updated Template', is_default: false)
  end

  def test_update_method_without_template_id
    assert_raises(ArgumentError) { templates.update(name: 'My Updated Template', is_default: false) }
  end

  def test_delete_method
    stub_request(:delete, template_uri).to_return(response)

    assert_kind_of Vonage::Response, templates.delete(template_id: template_id)
  end

  def test_delete_method_without_template_id
    assert_raises(ArgumentError) { templates.delete }
  end
end
