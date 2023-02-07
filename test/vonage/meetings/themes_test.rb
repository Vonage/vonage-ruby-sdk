# typed: false

class Vonage::Meetings::ThemesTest < Vonage::Test
  def themes
    Vonage::Meetings::Themes.new(config)
  end

  def themes_uri
    "https://" + meetings_host + "/beta/meetings/themes"
  end

  def theme_uri
    "https://" + meetings_host + "/beta/meetings/themes/" + meetings_id
  end

  def list_response
    {
      headers: response_headers,
      body: '[{"key":"value"}, {"key":"value"}, {"key":"value"}]'
    }
  end

  def test_list_method
    stub_request(:get, themes_uri).to_return(list_response)

    themes_list = themes.list

    assert_kind_of Vonage::Meetings::Themes::ListResponse, themes_list
    themes_list.each { |theme| assert_kind_of Vonage::Entity, theme }
  end

  def test_info_method
    stub_request(:get, theme_uri).to_return(response)

    assert_kind_of Vonage::Response, themes.info(theme_id: meetings_id)
  end

  def test_info_method_without_theme_id
    assert_raises(ArgumentError) { themes.info }
  end

  def test_create_method
    stub_request(:post, themes_uri).with(
      request(body: { main_color: "#12f64e", brand_text: "Brand" })
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   themes.create(main_color: "#12f64e", brand_text: "Brand")
  end

  def test_create_method_with_optional_arguments
    stub_request(:post, themes_uri).with(
      request(
        body: {
          main_color: "#12f64e",
          brand_text: "Brand",
          theme_name: "Theme A",
          short_company_url: "short-url"
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   themes.create(
                     main_color: "#12f64e",
                     brand_text: "Brand",
                     theme_name: "Theme A",
                     short_company_url: "short-url"
                   )
  end

  def test_create_method_without_main_color
    assert_raises(ArgumentError) { themes.create(brand_text: "Brand") }
  end

  def test_create_method_without_brand_text
    assert_raises(ArgumentError) { themes.create(main_color: "#12f64e") }
  end

  def test_update_method
    stub_request(:patch, theme_uri).to_return(response)

    assert_kind_of Vonage::Response, themes.update(theme_id: meetings_id)
  end

  def test_update_method_without_theme_id
    assert_raises(ArgumentError) { themes.update }
  end

  def test_update_method_with_optional_arguments
    stub_request(:patch, theme_uri).with(
      request(
        body: {
          update_details: {
            main_color: "#12f64e",
            brand_text: "Brand",
            theme_name: "Theme A",
            short_company_url: "short-url"
          }
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   themes.update(
                     theme_id: meetings_id,
                     main_color: "#12f64e",
                     brand_text: "Brand",
                     theme_name: "Theme A",
                     short_company_url: "short-url"
                   )
  end

  def test_delete_method
    stub_request(:delete, theme_uri + "?force=false").to_return(response)

    assert_kind_of Vonage::Response, themes.delete(theme_id: meetings_id)
  end

  def test_delete_method_with_force_set_to_true
    stub_request(:delete, theme_uri + "?force=true").to_return(response)

    assert_kind_of Vonage::Response,
                   themes.delete(theme_id: meetings_id, force: true)
  end

  def test_delete_method_without_theme_id
    assert_raises(ArgumentError) { themes.delete }
  end

  def test_list_rooms_method
    stub_request(:get, theme_uri + "/rooms").to_return(
      meetings_rooms_list_response_multiple
    )
    room_list = themes.list_rooms(theme_id: meetings_id)

    assert_kind_of Vonage::Meetings::Rooms::ListResponse, room_list
    room_list.each { |room| assert_kind_of Vonage::Entity, room }
  end

  def test_list_rooms_method_without_theme_id
    assert_raises(ArgumentError) { themes.list_rooms }
  end

  def test_list_rooms_method_with_optional_params
    stub_request(:get, theme_uri + "/rooms" + "?page_size=1").to_return(
      meetings_rooms_list_response_single
    )
    room_list = themes.list_rooms(theme_id: meetings_id, page_size: 1)

    assert_kind_of Vonage::Meetings::Rooms::ListResponse, room_list
    room_list.each { |room| assert_kind_of Vonage::Entity, room }
  end

  def test_upload_logo_method
    skip
  end

  def test_upload_logo_method_without_theme_id
    skip
  end
end
