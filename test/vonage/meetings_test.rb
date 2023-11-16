# typed: false
require_relative './test'

class Vonage::MeetingsTest < Vonage::Test
  def meetings
    Vonage::Meetings.new(config)
  end

  def test_rooms_method
    assert_kind_of Vonage::Meetings::Rooms, meetings.rooms
  end

  def test_recordings_method
    assert_kind_of Vonage::Meetings::Recordings, meetings.recordings
  end

  def test_sessions_method
    assert_kind_of Vonage::Meetings::Sessions, meetings.sessions
  end

  def test_themes_method
    assert_kind_of Vonage::Meetings::Themes, meetings.themes
  end

  def test_applications_method
    assert_kind_of Vonage::Meetings::Applications, meetings.applications
  end

  def test_dial_in_numbers_method
    assert_kind_of Vonage::Meetings::DialInNumbers, meetings.dial_in_numbers
  end
end
