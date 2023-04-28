# typed: false
require_relative './test'

class Vonage::ProactiveConnectTest < Vonage::Test
  def proactive_connect
    Vonage::ProactiveConnect.new(config)
  end

  def test_lists_method
    assert_kind_of Vonage::ProactiveConnect::Lists, proactive_connect.lists
  end

  def test_list_method
    assert_kind_of Vonage::ProactiveConnect::List, proactive_connect.list
  end

  def test_items_method
    assert_kind_of Vonage::ProactiveConnect::Items, proactive_connect.items
  end

  def test_item_method
    assert_kind_of Vonage::ProactiveConnect::Item, proactive_connect.item
  end

  def test_events_method
    assert_kind_of Vonage::ProactiveConnect::Events, proactive_connect.events
  end

  def test_webhooks_method
    assert_kind_of Vonage::ProactiveConnect::Webhooks, proactive_connect.webhooks
  end
end
