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

  def test_download_csv_method
    stub_request(:get, items_uri + '/download?order=asc').to_return(file_response)

    res = items.download_csv(list_id: list_id)

    assert_kind_of Vonage::ProactiveConnect::Items::FileResponse, res
    assert_equal "list-e546eebe-8e23-4e4d-bb7c-29d4700c9865-items.csv", res.filename
  end

  def test_download_csv_method_with_desc_order
    stub_request(:get, items_uri + '/download?order=desc').to_return(file_response)

    res = items.download_csv(list_id: list_id, order: 'desc')

    assert_kind_of Vonage::ProactiveConnect::Items::FileResponse, res
  end

  def test_download_csv_method_with_default_filename
    stub_request(:get, items_uri + '/download?order=asc').to_return(file_response_without_filename)

    res = items.download_csv(list_id: list_id)

    assert_kind_of Vonage::ProactiveConnect::Items::FileResponse, res
    assert_equal "vonage-proactive-connect-list-items.csv", res.filename
  end

  def test_download_csv_method_with_specified_filename
    stub_request(:get, items_uri + '/download?order=asc').to_return(file_response)

    res = items.download_csv(list_id: list_id, filename: 'foo.csv')

    assert_kind_of Vonage::ProactiveConnect::Items::FileResponse, res
    assert_equal "foo.csv", res.filename
  end

  def test_download_csv_method_without_list_id
    assert_raises(ArgumentError) { items.download_csv }
  end

  def test_upload_csv_method
    stub_request(:post, items_uri + "/import").with(headers: {'Authorization' => authorization}).to_return(response)

    csv_rows = <<~eos
      Name1,name1@example.com
      Name2,name2@example.com
      Name3,name3@example.com
    eos
    file = Tempfile.create(['new_users', '.csv'])
    file.write(csv_rows)
    file.rewind

    assert_kind_of Vonage::Response, items.upload_csv(list_id: list_id, filepath: file.path)
  end

  def test_upload_csv_method_with_invalid_filepath
    assert_raises(ArgumentError) { items.upload_csv(list_id: list_id, filepath: 'foo/bar/file.csv') }
  end

  def test_upload_csv_method_with_non_csv_file
    file = Tempfile.create(['new_users', '.txt'])
    assert_raises(ArgumentError) { items.upload_csv(list_id: list_id, filepath: file.path) }
  end

  def test_upload_csv_method_without_list_id
    assert_raises(ArgumentError) { items.upload_csv(filepath: 'foo/bar/file.csv') }
  end

  def test_upload_csv_method_without_filepath
    assert_raises(ArgumentError) { items.upload_csv(list_id: list_id) }
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

  def file_response
    {
      headers: {
        "content-type"=>["text/csv"],
        "content-disposition"=>["attachment; filename=\"list-e546eebe-8e23-4e4d-bb7c-29d4700c9865-items.csv\""]
      },
      body: "\"Name\",\"Email\"\n\"Bob\",\"bob@email.com\"\n"
    }
  end

  def file_response_without_filename
    {
      headers: {
        "content-type"=>["text/csv"],
        "content-disposition"=>["attachment"]
      },
      body: "\"Name\",\"Email\"\n\"Bob\",\"bob@email.com\"\n"
    }
  end
end
