# typed: false
require_relative './test'

class Vonage::ReportsTest < Vonage::Test
  def reports
    Vonage::Reports.new(config)
  end

  def test_get_records_method
    uri = 'https://api.nexmo.com/v2/reports/records'

    params = {
      account_id: 'abc123',
      direction: 'outbound',
      date_start: '2024-01-01',
      date_end: '2024-01-31'
    }

    stub_request(:get, uri)
      .with(query: params, headers: {'Authorization' => basic_authorization})
      .to_return(response)

    assert_kind_of Vonage::Response, reports.get_records(params)
  end

  def test_get_records_method_with_no_params
    uri = 'https://api.nexmo.com/v2/reports/records'

    stub_request(:get, uri)
      .with(headers: {'Authorization' => basic_authorization})
      .to_return(response)

    assert_kind_of Vonage::Response, reports.get_records
  end
end 