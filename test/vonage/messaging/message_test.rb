# typed: false

class Vonage::Messaging::MessageTest < Vonage::Test
  def message_class
    Vonage::Messaging::Message
  end

  def test_message_with_valid_channel
    channel_obj_data = message_class.sms(message: "Hello world!")
    expected_data = {:channel=>"sms", :message_type=>"text", :text=>"Hello world!"}

    assert_equal channel_obj_data, expected_data
  end

  def test_message_with_valid_channel_and_optional_parameters
    channel_obj_data = message_class.sms(message: "Hello world!", opts: {client_ref: "abc123"})
    expected_data = {:channel=>"sms", :message_type=>"text", :text=>"Hello world!", :client_ref=>"abc123"}

    assert_equal channel_obj_data, expected_data
  end

  def test_message_with_invalid_channel
    exception = assert_raises { message_class.telepaphy }

    assert_match "Messaging channel must be one of the valid options.", exception.message
  end

  Vonage::Messaging::Message::CHANNELS.keys.each do |method_name|
    define_method "test_message_class_#{method_name}_defined_class_method" do
      assert_respond_to message_class, method_name
    end
  end
end
