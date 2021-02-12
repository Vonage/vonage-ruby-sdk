# typed: false


class Vonage::Voice::Actions::NotifyTest < Vonage::Test
  def test_notify_initialize
    notify = Vonage::Voice::Actions::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ])

    assert_kind_of Vonage::Voice::Actions::Notify, notify
    assert_equal notify.eventUrl, ['https://example.com']
  end

  def test_create_notify
    expected = [{ action: 'notify', payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ] }]
    notify = Vonage::Voice::Actions::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ])

    assert_equal expected, notify.create_notify!(notify)
  end

  def test_create_notify_with_optional_params
    expected = [{ action: 'notify', payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ], eventMethod: 'POST' }]
    notify = Vonage::Voice::Actions::Notify.new(payload: { foo: 'bar' }, eventUrl: [ 'https://example.com' ], eventMethod: 'POST')

    assert_equal expected, notify.create_notify!(notify)
  end
end