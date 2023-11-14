# typed: strict
# frozen_string_literal: true

module Vonage
  class Meetings < Namespace
    extend T::Sig
    
    sig { returns(T.nilable(Vonage::Meetings::Rooms)) }
    def rooms
      @rooms ||= Rooms.new(@config)
    end

    sig { returns(T.nilable(Vonage::Meetings::Recordings)) }
    def recordings
      @recordings ||= Recordings.new(@config)
    end

    sig { returns(T.nilable(Vonage::Meetings::Sessions)) }
    def sessions
      @sessions ||= Sessions.new(@config)
    end

    sig { returns(T.nilable(Vonage::Meetings::Themes)) }
    def themes
      @themes ||= Themes.new(@config)
    end

    sig { returns(T.nilable(Vonage::Meetings::Applications)) }
    def applications
      @applications ||= Applications.new(@config)
    end

    sig { returns(T.nilable(Vonage::Meetings::DialInNumbers)) }
    def dial_in_numbers
      @dial_in_numbers ||= DialInNumbers.new(@config)
    end
  end
end