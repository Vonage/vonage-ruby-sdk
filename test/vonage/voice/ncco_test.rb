# typed: false

class Vonage::Voice::NccoTest < Vonage::Test
  def ncco
    Vonage::Voice::Ncco
  end

  def test_ncco_with_valid_action
    action = ncco.connect(endpoint: { type: 'phone', number: '12129999999' })

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"12129999999"}]}]
  end

  def test_ncco_with_valid_action_and_optional_parameters
    action = ncco.connect(endpoint: { type: 'phone', number: '12129999999' }, from: '12129992222')

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"12129999999"}], :from=>'12129992222'}]
  end

  def test_ncco_connect_action_sip_endpoint_with_standard_headers
    action = ncco.connect(
      endpoint: {
        type: 'sip',
        uri: 'sip:rebekka@sip.mcrussell.com',
        headers: {
          location: 'New York',
          occupation: 'developer'
        },
        standardHeaders: {
          'User-to-User' => '56a390f3d2b7310023a2;encoding=hex;purpose=foo;content=bar'
        }
      }
    )

    action_literal = [
      {
        :action=>"connect",
        :endpoint=>[
          {
            :type=>"sip",
            :uri=>"sip:rebekka@sip.mcrussell.com",
            :headers=>{
              location: 'New York',
              occupation: 'developer'
            },
            :standardHeaders => {
              'User-to-User' => '56a390f3d2b7310023a2;encoding=hex;purpose=foo;content=bar'
            }
          }
        ]
      }
    ]

    assert_equal action_literal, action
  end

  def test_ncco_with_invalid_action
    exception = assert_raises { ncco.gotowarp }
    
    assert_match "NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.", exception.message
  end

  Vonage::Voice::Ncco::ACTIONS.keys.each do |method_name|
    define_method "test_ncco_#{method_name}_defined_class_method" do
      assert_respond_to ncco, method_name
      refute_respond_to ncco.class, method_name
    end
  end
end
