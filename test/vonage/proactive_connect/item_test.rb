# typed: false

class Vonage::ProactiveConnect::ItemTest < Vonage::Test
  def item
    Vonage::ProactiveConnect::Item.new(config)
  end

  def list_id
    "29192c4a-4058-49da-86c2-3e349d1065b7"
  end

  def item_id
    "4cb98f71-a879-49f7-b5cf-2314353eb52c"
  end

  def item_uri
    "https://" + vonage_host + "/v0.1/bulk/lists/#{list_id}/items"
  end

  def test_create_method
    stub_request(:post, item_uri).with(
      request(
        body: {
          data: {
            first_name: "Adrianna",
            last_name: "Campbell",
            phone: "15550067383"
          }
        }
      )
    ).to_return(response)

    data =  {
      first_name: "Adrianna",
      last_name: "Campbell",
      phone: "15550067383"
    }

    assert_kind_of Vonage::Response, item.create(list_id: list_id, data: data)
  end

  def test_create_method_without_list_id
    data =  {
      first_name: "Adrianna",
      last_name: "Campbell",
      phone: "15550067383"
    }

    assert_raises(ArgumentError) { item.create(data: data) }
  end

  def test_create_method_without_data
    assert_raises(ArgumentError) { item.create(list_id: list_id) }
  end

  def test_create_method_with_incorrect_data_type
    assert_raises(ArgumentError) { item.create(list_id: list_id, data: 'foo') }
  end

  def test_find_method
    stub_request(:get, item_uri + "/#{item_id}").to_return(response)

    assert_kind_of Vonage::Response, item.find(list_id: list_id, item_id: item_id)
  end

  def test_find_method_without_list_id
    assert_raises(ArgumentError) { item.find(item_id: item_id) }
  end

  def test_find_method_without_item_id
    assert_raises(ArgumentError) { item.find(list_id: list_id) }
  end

  def test_update_method
    stub_request(:put, item_uri + "/#{item_id}").with(
      request(
        body: {
          data: {
            first_name: "Adrianna",
            last_name: "Campbell",
            phone: "15550067384"
          }
        }
      )
    ).to_return(response)

    data =  {
      first_name: "Adrianna",
      last_name: "Campbell",
      phone: "15550067384"
    }

    assert_kind_of Vonage::Response, item.update(list_id: list_id, item_id: item_id, data: data)
  end

  def test_update_method_without_list_id
    data =  {
      first_name: "Adrianna",
      last_name: "Campbell",
      phone: "15550067384"
    }

    assert_raises(ArgumentError) { item.update(item_id: item_id, data: data) }
  end

  def test_update_method_without_item_id
    data =  {
      first_name: "Adrianna",
      last_name: "Campbell",
      phone: "15550067384"
    }

    assert_raises(ArgumentError) { item.update(list_id: list_id, data: data) }
  end

  def test_update_method_without_data
    assert_raises(ArgumentError) { item.update(list_id: list_id, item_id: item_id) }
  end

  def test_update_method_with_incorrect_data_type
    assert_raises(ArgumentError) { item.update(list_id: list_id, item_id: item_id, data: "foo") }
  end

  def test_delete_method
    stub_request(:delete, item_uri + "/#{item_id}").to_return(response)

    assert_kind_of Vonage::Response, item.delete(list_id: list_id, item_id: item_id)
  end

  def test_delete_method_without_list_id
    assert_raises(ArgumentError) { item.delete(item_id: item_id) }
  end

  def test_delete_method_without_item_id
    assert_raises(ArgumentError) { item.delete(list_id: list_id) }
  end
end
