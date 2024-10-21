# typed: false

class Vonage::Verify2::TemplateFragmentsTest < Vonage::Test
  def template_fragments
    Vonage::Verify2::TemplateFragments.new(config)
  end

  def template_id
    '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9'
  end

  def template_fragment_id
    'c70f446e-997a-4313-a081-60a02a31dc19'
  end

  def template_fragments_uri
    'https://api.nexmo.com/v2/verify/templates/' + template_id + '/template_fragments'
  end

  def template_fragment_uri
    'https://api.nexmo.com/v2/verify/templates/' + template_id + '/template_fragments/' + template_fragment_id
  end

  def template_fragments_list_response
    { body: '{"_embedded": {"template_fragments":[{"key":"value"}]}}', headers: response_headers }
  end

  def test_list_method
    stub_request(:get, template_fragments_uri).to_return(template_fragments_list_response)

    template_fragments_list = template_fragments.list(template_id: template_id)

    assert_kind_of Vonage::Verify2::TemplateFragments::ListResponse, template_fragments_list
    template_fragments_list.each { |template_fragment| assert_kind_of Vonage::Entity, template_fragment }
  end

  def test_list_method_with_optional_params
    stub_request(:get, template_fragments_uri + '?page_size=10&page=2').to_return(template_fragments_list_response)

    template_fragments_list = template_fragments.list(template_id: template_id, page_size: 10, page: 2)

    assert_kind_of Vonage::Verify2::TemplateFragments::ListResponse, template_fragments_list
    template_fragments_list.each { |template_fragment| assert_kind_of Vonage::Entity, template_fragment }
  end

  def test_list_method_without_template_id
    assert_raises(ArgumentError) { template_fragments.list }
  end

  def test_info_method
    stub_request(:get, template_fragment_uri).to_return(response)

    assert_kind_of Vonage::Response, template_fragments.info(template_id: template_id, template_fragment_id: template_fragment_id)
  end

  def test_info_method_without_template_id
    assert_raises(ArgumentError) { template_fragments.info(template_fragment_id: template_fragment_id) }
  end

  def test_info_method_without_template_fragment_id
    assert_raises(ArgumentError) { template_fragments.info(template_id: template_id) }
  end

  def test_create_method
    stub_request(:post, template_fragments_uri).with(body: { channel: 'sms', locale: 'en-gb', text: 'Code: ${code}' }).to_return(response)

    assert_kind_of Vonage::Response, template_fragments.create(template_id: template_id, channel: 'sms', locale: 'en-gb', text: 'Code: ${code}')
  end

  def test_create_method_without_template_id
    assert_raises(ArgumentError) { template_fragments.create(channel: 'sms', locale: 'en-gb', text: 'Code: ${code}') }
  end

  def test_create_method_without_channel
    assert_raises(ArgumentError) { template_fragments.create(template_id: template_id, locale: 'en-gb', text: 'Code: ${code}') }
  end

  def test_create_method_without_locale
    assert_raises(ArgumentError) { template_fragments.create(template_id: template_id, channel: 'sms', text: 'Code: ${code}') }
  end

  def test_create_method_without_text
    assert_raises(ArgumentError) { template_fragments.create(template_id: template_id, channel: 'sms', locale: 'en-gb') }
  end

  def test_create_method_with_invalid_channel
    assert_raises(ArgumentError) { template_fragments.create(template_id: template_id, channel: 'foo', locale: 'en-gb', text: 'Code: ${code}') }
  end

  def test_update_method
    stub_request(:patch, template_fragment_uri).with(body: { text: 'Your code is: ${code}' }).to_return(response)

    assert_kind_of Vonage::Response, template_fragments.update(template_id: template_id, template_fragment_id: template_fragment_id, text: 'Your code is: ${code}')
  end

  def test_update_method_without_template_id
    assert_raises(ArgumentError) { template_fragments.update(template_fragment_id: template_fragment_id, text: 'Your code is: ${code}') }
  end

  def test_update_method_without_template_fragment_id
    assert_raises(ArgumentError) { template_fragments.update(template_id: template_id, text: 'Your code is: ${code}') }
  end

  def test_update_method_without_text
    assert_raises(ArgumentError) { template_fragments.update(template_id: template_id, template_fragment_id: template_fragment_id) }
  end

  def test_delete_method
    stub_request(:delete, template_fragment_uri).to_return(response)

    assert_kind_of Vonage::Response, template_fragments.delete(template_id: template_id, template_fragment_id: template_fragment_id)
  end

  def test_delete_method_without_template_id
    assert_raises(ArgumentError) { template_fragments.delete(template_fragment_id: template_fragment_id) }
  end

  def test_delete_method_without_template_fragment_id
    assert_raises(ArgumentError) { template_fragments.delete(template_id: template_id) }
  end
end
