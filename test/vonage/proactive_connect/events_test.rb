# typed: false

class Vonage::ProactiveConnect::EventsTest < Vonage::Test
  def events
    Vonage::ProactiveConnect::Events.new(config)
  end

  def events_uri
    "https://" + vonage_host + "/v0.1/bulk/events"
  end

  def test_list_method
    stub_request(:get, events_uri).to_return(
      response
    )
    events_list = events.list

    assert_kind_of Vonage::ProactiveConnect::Events::ListResponse, events_list
    events_list.each { |event| assert_kind_of Vonage::Entity, event }
  end

  def test_list_method_with_optional_params
    stub_request(:get, events_uri + "?page=2&page_size=1").to_return(
      paginated_response
    )
    events_list = events.list(page: 2, page_size: 1)

    assert_kind_of Vonage::ProactiveConnect::Events::ListResponse, events_list
    events_list.each { |event| assert_kind_of Vonage::Entity, event }
  end

  def response
    {
      body: '{
        "total_items": 1,
        "page": 1,
        "page_size": 100,
        "total_pages": 1,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          }
        },
        "_embedded": {
          "events": [
            {
              "occurred_at": "2022-08-07T13:18:21.970Z",
              "type": "action-call-succeeded",
              "id": "e8e1eb4d-61e0-4099-8fa7-c96f1c0764ba",
              "job_id": "c68e871a-c239-474d-a905-7b95f4563b7e",
              "src_ctx": "et-e4ab4b75-9e7c-4f26-9328-394a5b842648",
              "action_id": "26c5bbe2-113e-4201-bd93-f69e0a03d17f",
              "data": {
                "url": "https://postman-echo.com/post",
                "args": {},
                "data": {
                  "from": ""
                },
                "form": {},
                "json": {
                  "from": ""
                },
                "files": {},
                "headers": {
                  "host": "postman-echo.com",
                  "user-agent": "got (https://github.com/sindresorhus/got)",
                  "content-type": "application/json",
                  "content-length": "11",
                  "accept-encoding": "gzip, deflate, br",
                  "x-amzn-trace-id": "Root=1-62efbb9e-53636b7b794accb87a3d662f",
                  "x-forwarded-port": "443",
                  "x-nexmo-trace-id": "8a6fed94-7296-4a39-9c52-348f12b4d61a",
                  "x-forwarded-proto": "https"
                }
              },
              "run_id": "7d0d4e5f-6453-4c63-87cf-f95b04377324",
              "recipient_id": "14806904549"
            },
            {
              "occurred_at": "2022-08-07T13:18:20.289Z",
              "type": "recipient-response",
              "id": "8c8e9894-81be-4f6e-88d4-046b6c70ff8c",
              "job_id": "c68e871a-c239-474d-a905-7b95f4563b7e",
              "src_ctx": "et-e4ab4b75-9e7c-4f26-9328-394a5b842648",
              "data": {
                "from": "441632960411",
                "text": "Erin J. Yearby"
              },
              "run_id": "7d0d4e5f-6453-4c63-87cf-f95b04377324",
              "recipient_id": "441632960758"
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
        "total_items": 1,
        "page": 2,
        "page_size": 100,
        "total_pages": 1,
        "_links": {
          "self": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=2"
          },
          "prev": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          },
          "next": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=3"
          },
          "first": {
            "href": "https://api-eu.vonage.com/v0.1/bulk/events?page_size=100&page=1"
          }
        },
        "_embedded": {
          "events": [
            {
              "occurred_at": "2022-08-07T13:18:21.970Z",
              "type": "action-call-succeeded",
              "id": "e8e1eb4d-61e0-4099-8fa7-c96f1c0764ba",
              "job_id": "c68e871a-c239-474d-a905-7b95f4563b7e",
              "src_ctx": "et-e4ab4b75-9e7c-4f26-9328-394a5b842648",
              "action_id": "26c5bbe2-113e-4201-bd93-f69e0a03d17f",
              "data": {
                "url": "https://postman-echo.com/post",
                "args": {},
                "data": {
                  "from": ""
                },
                "form": {},
                "json": {
                  "from": ""
                },
                "files": {},
                "headers": {
                  "host": "postman-echo.com",
                  "user-agent": "got (https://github.com/sindresorhus/got)",
                  "content-type": "application/json",
                  "content-length": "11",
                  "accept-encoding": "gzip, deflate, br",
                  "x-amzn-trace-id": "Root=1-62efbb9e-53636b7b794accb87a3d662f",
                  "x-forwarded-port": "443",
                  "x-nexmo-trace-id": "8a6fed94-7296-4a39-9c52-348f12b4d61a",
                  "x-forwarded-proto": "https"
                }
              },
              "run_id": "7d0d4e5f-6453-4c63-87cf-f95b04377324",
              "recipient_id": "14806904549"
            },
            {
              "occurred_at": "2022-08-07T13:18:20.289Z",
              "type": "recipient-response",
              "id": "8c8e9894-81be-4f6e-88d4-046b6c70ff8c",
              "job_id": "c68e871a-c239-474d-a905-7b95f4563b7e",
              "src_ctx": "et-e4ab4b75-9e7c-4f26-9328-394a5b842648",
              "data": {
                "from": "441632960411",
                "text": "Erin J. Yearby"
              },
              "run_id": "7d0d4e5f-6453-4c63-87cf-f95b04377324",
              "recipient_id": "441632960758"
            }
          ]
        }
      }',
      headers: response_headers
    }
  end
end
