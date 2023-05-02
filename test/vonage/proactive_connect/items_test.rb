# typed: false

class Vonage::ProactiveConnect::ItemsTest < Vonage::Test
  def items
    Vonage::ProactiveConnect::Items.new(config)
  end

  def list_id
    "29192c4a-4058-49da-86c2-3e349d1065b7"
  end

  def items_uri
    "https://" + vonage_host + "/v0.1/bulk/lists/#{list_id}/items"
  end

  def test_list_method
    stub_request(:get, items_uri).to_return(
      list_response
    )
    items_list = items.list(list_id: list_id)

    assert_kind_of Vonage::ProactiveConnect::Items::ListResponse, items_list
    items_list.each { |item| assert_kind_of Vonage::Entity, item }
  end

  def test_list_method_with_optional_params
    stub_request(:get, items_uri + "?page=2&page_size=1").to_return(
      paginated_list_response
    )
    items_list = items.list(list_id: list_id, page: 2, page_size: 1)

    assert_kind_of Vonage::ProactiveConnect::Items::ListResponse, items_list
    items_list.each { |item| assert_kind_of Vonage::Entity, item }
  end

  def test_list_method_without_list_id
    assert_raises(ArgumentError) { items.list }
  end

  def list_response
    {
      body: '{
        "total_items": 2,
        "page": 1,
        "page_size": 100,
        "total_pages": 1,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          }
        },
        "_embedded": {
          "items": [
            {
              "id": "6e26d247-e074-4f68-b72b-dd92aa02c7e0",
              "created_at": "2022-08-03T08:54:21.122Z",
              "updated_at": "2022-08-03T08:54:21.122Z",
              "list_id": "060b9c33-6c81-4fe4-9621-b10c0a4c06f3",
              "data": {
                "Id": "0038d00000B22zbAAB",
                "Email": "info@salesforce.com",
                "Phone": "(415) 555-1212",
                "LastName": "Minor",
                "FirstName": "Geoff",
                "OtherCountry": "Canada"
              }
            },
            {
              "id": "f7c029ad-93c3-469c-9267-73c3c6864161",
              "created_at": "2022-08-03T08:54:21.122Z",
              "updated_at": "2022-08-03T08:54:21.122Z",
              "list_id": "060b9c33-6c81-4fe4-9621-b10c0a4c06f3",
              "data": {
                "Id": "0038d00000B22zcAAB",
                "Email": "info@salesforce.com",
                "Phone": "(415) 555-1212",
                "LastName": "White",
                "FirstName": "Carole",
                "OtherCountry": null
              }
            }
          ]
        }
      }',
      headers: response_headers
    }
  end

  def paginated_list_response
    {
      body: '{
        "total_items": 1,
        "page": 2,
        "page_size": 100,
        "total_pages": 2,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=2"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=3"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists/060b9c33-6c81-4fe4-9621-b10c0a4c06f3/items/?page_size=100&page=1"
          }
        },
        "_embedded": {
          "items": [
            {
              "id": "6e26d247-e074-4f68-b72b-dd92aa02c7e0",
              "created_at": "2022-08-03T08:54:21.122Z",
              "updated_at": "2022-08-03T08:54:21.122Z",
              "list_id": "060b9c33-6c81-4fe4-9621-b10c0a4c06f3",
              "data": {
                "Id": "0038d00000B22zbAAB",
                "Email": "info@salesforce.com",
                "Phone": "(415) 555-1212",
                "LastName": "Minor",
                "FirstName": "Geoff",
                "OtherCountry": "Canada"
              }
            }
          ]
        }
      }',
      headers: response_headers
    }
  end
end
