# typed: false

class Vonage::ProactiveConnect::ListsTest < Vonage::Test
  def lists
    Vonage::ProactiveConnect::Lists.new(config)
  end

  def lists_uri
    "https://" + vonage_host + "/v0.1/bulk/lists"
  end

  def test_list_method
    stub_request(:get, lists_uri).to_return(
      response
    )
    list = lists.list

    assert_kind_of Vonage::ProactiveConnect::Lists::ListResponse, list
    list.each { |list| assert_kind_of Vonage::Entity, list }
  end

  def test_list_method_with_optional_params
    stub_request(:get, lists_uri + "?page=2&page_size=1").to_return(
      paginated_response
    )
    list = lists.list(page: 2, page_size: 1)

    assert_kind_of Vonage::ProactiveConnect::Lists::ListResponse, list
    list.each { |list| assert_kind_of Vonage::Entity, list }
  end

  def response
    {
      body: '{
        "page": 1,
        "page_size": 100,
        "total_items": 2,
        "total_pages": 1,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=2"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          }
        },
        "_embedded": {
          "lists": [
            {
              "name": "Recipients for demo",
              "description": "List of recipients for demo",
              "tags": [
                "vip"
              ],
              "attributes": [
                {
                  "name": "firstName"
                },
                {
                  "name": "lastName",
                  "key": false
                },
                {
                  "name": "number",
                  "alias": "Phone",
                  "key": true
                }
              ],
              "datasource": {
                "type": "manual"
              },
              "items_count": 1000,
              "sync_status": {
                "value": "configured",
                "dirty": false,
                "data_modified": false,
                "metadata_modified": false
              },
              "id": "af8a84b6-c712-4252-ac8d-6e28ac9317ce",
              "created_at": "2022-06-23T13:13:16.491Z",
              "updated_at": "2022-06-23T13:13:16.491Z"
            },
            {
              "name": "Salesforce contacts",
              "description": "Salesforce contacts for campaign",
              "tags": [
                "salesforce"
              ],
              "attributes": [
                {
                  "name": "Id",
                  "key": false
                },
                {
                  "name": "Phone",
                  "key": true
                },
                {
                  "name": "Email",
                  "key": false
                }
              ],
              "datasource": {
                "type": "salesforce",
                "integration_id": "salesforce",
                "soql": "SELECT Id, LastName, FirstName, Phone, Email, OtherCountry FROM Contact"
              }
            }
          ]
        }
      }',
      headers: response_headers
    }
  end

  def paginated_response
    {
      body: '{
        "page": 1,
        "page_size": 100,
        "total_items": 2,
        "total_pages": 1,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=2"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/lists?page_size=100&page=1"
          }
        },
        "_embedded": {
          "lists": [
            {
              "name": "Recipients for demo",
              "description": "List of recipients for demo",
              "tags": [
                "vip"
              ],
              "attributes": [
                {
                  "name": "firstName"
                },
                {
                  "name": "lastName",
                  "key": false
                },
                {
                  "name": "number",
                  "alias": "Phone",
                  "key": true
                }
              ],
              "datasource": {
                "type": "manual"
              },
              "items_count": 1000,
              "sync_status": {
                "value": "configured",
                "dirty": false,
                "data_modified": false,
                "metadata_modified": false
              },
              "id": "af8a84b6-c712-4252-ac8d-6e28ac9317ce",
              "created_at": "2022-06-23T13:13:16.491Z",
              "updated_at": "2022-06-23T13:13:16.491Z"
            }
          ]
        }
      }',
      headers: response_headers
    }
  end
end
