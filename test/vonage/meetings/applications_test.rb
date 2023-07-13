# typed: false

class Vonage::Meetings::ApplicationsTest < Vonage::Test
  def applications
    Vonage::Meetings::Applications.new(config)
  end

  def applications_uri
    "https://" + meetings_host + "/meetings/applications"
  end

  def test_update_method
    stub_request(:patch, applications_uri).with(
      request(
        body: {
          update_details: {
            default_theme_id: "aecda5ae-6296-42df-a881-67bdd1ecacb8"
          }
        }
      )
    ).to_return(response)

    assert_kind_of Vonage::Response, applications.update(default_theme_id: "aecda5ae-6296-42df-a881-67bdd1ecacb8")
  end

  def test_update_method_without_default_theme_id
    assert_raises(ArgumentError) { applications.update }
  end
end
