# typed: false

class Vonage::Meetings::RoomsTest < Vonage::Test
  def rooms
    Vonage::Meetings::Rooms.new(config)
  end

  def rooms_uri
    "https://" + meetings_host + "/meetings/rooms"
  end

  def room_uri
    "https://" + meetings_host + "/meetings/rooms/" + meetings_id
  end

  def test_list_method
    stub_request(:get, rooms_uri).to_return(
      meetings_rooms_list_response_multiple
    )
    room_list = rooms.list

    assert_kind_of Vonage::Meetings::Rooms::ListResponse, room_list
    room_list.each { |room| assert_kind_of Vonage::Entity, room }
  end

  def test_list_method_with_optional_params
    stub_request(:get, rooms_uri + "?page_size=1").to_return(
      meetings_rooms_list_response_single
    )
    room_list = rooms.list(page_size: 1)

    assert_kind_of Vonage::Meetings::Rooms::ListResponse, room_list
    room_list.each { |room| assert_kind_of Vonage::Entity, room }
  end

  def test_info_method
    stub_request(:get, room_uri).to_return(response)

    assert_kind_of Vonage::Response, rooms.info(room_id: meetings_id)
  end

  def test_info_method_without_room_id
    assert_raises(ArgumentError) { rooms.info }
  end

  def test_create_method
    stub_request(:post, rooms_uri).with(
      request(body: { display_name: "Test Room" })
    ).to_return(response)

    assert_kind_of Vonage::Response, rooms.create(display_name: "Test Room")
  end

  def test_create_method_with_optional_arguments
    stub_request(:post, rooms_uri).with(
      request(
        body: {
          display_name: "Test Room",
          type: "long_term",
          expires_at: "2023-01-30 15:00:00.000"
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   rooms.create(
                     display_name: "Test Room",
                     type: "long_term",
                     expires_at: "2023-01-30 15:00:00.000"
                   )
  end

  def test_create_method_without_display_name
    assert_raises(ArgumentError) { rooms.create }
  end

  def test_update_method
    stub_request(:patch, room_uri).with(
      request(
        body: {
          update_details: {
            expires_at: "2023-01-30 15:00:00.000"
          }
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   rooms.update(
                     room_id: meetings_id,
                     expires_at: "2023-01-30 15:00:00.000"
                   )
  end

  def test_update_method_without_room_id
    assert_raises(ArgumentError) { rooms.update(expires_at: "2023-01-30 15:00:00.000") }
  end

  def test_update_method_without_additional_keyword_argument
    assert_raises(ArgumentError) { rooms.update(room_id: meetings_id) }
  end
end
