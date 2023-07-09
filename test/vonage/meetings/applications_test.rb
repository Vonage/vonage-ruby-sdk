# typed: false

class Vonage::Meetings::ApplicationsTest < Vonage::Test
  def applications
    Vonage::Meetings::Applications.new(config)
  end

  def applications_uri
    "https://" + meetings_host + "/beta/meetings/applications"
  end

  def test_update_method
    stub_request(:patch, applications_uri).to_return(response)

    assert_kind_of Vonage::Response, applications.update
  end

  def test_update_method_with_optional_arguments
    stub_request(:patch, applications_uri).with(
      request(
        body: {
          default_theme_id: "aecda5ae-6296-42df-a881-67bdd1ecacb8"
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response,
                   applications.update(
                     default_theme_id: "aecda5ae-6296-42df-a881-67bdd1ecacb8"
                   )
  end
end
