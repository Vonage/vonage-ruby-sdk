# typed: strict
# frozen_string_literal: true

module Vonage
  class Meetings < Namespace
    extend T::Sig
    
    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::Rooms)) }
    def rooms
      logger.info('This method is deprecated and will be removed in a future release.')
      @rooms ||= Rooms.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::Recordings)) }
    def recordings
      logger.info('This method is deprecated and will be removed in a future release.')
      @recordings ||= Recordings.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::Sessions)) }
    def sessions
      logger.info('This method is deprecated and will be removed in a future release.')
      @sessions ||= Sessions.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::Themes)) }
    def themes
      logger.info('This method is deprecated and will be removed in a future release.')
      @themes ||= Themes.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::Applications)) }
    def applications
      logger.info('This method is deprecated and will be removed in a future release.')
      @applications ||= Applications.new(@config)
    end

    # @deprecated
    sig { returns(T.nilable(Vonage::Meetings::DialInNumbers)) }
    def dial_in_numbers
      logger.info('This method is deprecated and will be removed in a future release.')
      @dial_in_numbers ||= DialInNumbers.new(@config)
    end
  end
end