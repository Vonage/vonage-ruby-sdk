# typed: false

class Vonage::ProactiveConnect::ListTest < Vonage::Test
  def list
    Vonage::ProactiveConnect::List.new(config)
  end

  def list_uri
    "https://" + vonage_host + "/v0.1/bulk/lists"
  end

  def list_id
    "29192c4a-4058-49da-86c2-3e349d1065b7"
  end

  def test_create_method
    stub_request(:post, list_uri).with(
      request(body: { name: "Test List" })
    ).to_return(response)

    assert_kind_of Vonage::Response, list.create(name: "Test List")
  end

  def test_create_method_with_optional_params
    skip
    stub_request(:post, list_uri).with(
      request(body: { name: "Test List", description: "foo", tags: ["bar", "baz"]})
    ).to_return(response)

    assert_kind_of Vonage::Response, list.create(name: "Test List", description: "foo", tags: ["bar", "baz"])
  end

  def test_create_method_without_name
    skip
    assert_raises(ArgumentError) { list.create }
  end

  def test_find_method
    skip
    stub_request(:get, list_uri + "/#{list_id}").to_return(response)

    assert_kind_of Vonage::Response, list.find(id: list_id)
  end

  def test_find_method_without_id
    skip
    assert_raises(ArgumentError) { list.find }
  end

  def test_update_method
    skip
    stub_request(:put, list_uri + "/#{list_id}").with(
      request(body: { name: "Test List Updated" })
    ).to_return(response)

    assert_kind_of Vonage::Response, list.create(id: list_id, name: "Test List Updated")
  end

  def test_update_method_with_optional_params
    skip
    stub_request(:put, list_uri + "/#{list_id}").with(
      request(body: { name: "Test List Updated", description: "qux", tags: ["quux", "xyzzy"]})
    ).to_return(response)

    assert_kind_of Vonage::Response, list.create(id: list_id, name: "Test List Updated", description: "qux", tags: ["quux", "xyzzy"])
  end

  def test_update_method_without_id
    skip
    assert_raises(ArgumentError) { list.create(name: "Test List Updated") }
  end

  def test_update_method_without_name
    skip
    assert_raises(ArgumentError) { list.create(id: list_id) }
  end

  def test_delete_method
    skip
    stub_request(:delete, list_uri + "/#{list_id}").to_return(response)

    assert_kind_of Vonage::Response, list.delete(id: list_id)
  end

  def test_delete_method_without_id
    skip
    assert_raises(ArgumentError) { list.delete }
  end

  def test_clear_items_method
    skip
    stub_request(:post, list_uri + "/#{list_id}/clear").to_return(response)

    assert_kind_of Vonage::Response, list.clear_items(id: list_id)
  end

  def test_clear_items_method_without_id
    skip
    assert_raises(ArgumentError) { list.clear_items }
  end

  def test_fetch_and_replace_items_method
    skip
    stub_request(:post, list_uri + "/#{list_id}/fetch").to_return(response)

    assert_kind_of Vonage::Response, list.fetch_and_replace(id: list_id)
  end

  def test_fetch_and_replace_items_method_without_id
    skip
    assert_raises(ArgumentError) { list.fetch_and_replace }
  end
end
