# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::StartVerificationOptions
    VALID_OPTS = [:locale, :channel_timeout, :client_ref, :code_length, :code].freeze

    VALID_LOCALES = [
      'en-us', 'en-gb', 'es-es', 'es-mx', 'es-us', 'it-it', 'fr-fr',
      'de-de', 'ru-ru', 'hi-in', 'pt-br', 'pt-pt', 'id-id'
    ].freeze

    MIN_CHANNEL_TIMEOUT, MAX_CHANNEL_TIMEOUT = [60, 900]

    MIN_CODE_LENGTH, MAX_CODE_LENGTH = [4, 10]

    attr_reader(*VALID_OPTS)

    def initialize(**opts)
      VALID_OPTS.each do |opt|
        send("#{opt}=", opts[opt]) unless opts[opt].nil?
      end
    end

    def locale=(locale)
      unless VALID_LOCALES.include?(locale)
        raise ArgumentError, "Invalid 'locale' #{locale}. Please choose from the following #{VALID_LOCALES}"
      end

      @locale = locale
    end

    def channel_timeout=(channel_timeout)
      unless channel_timeout.between?(MIN_CHANNEL_TIMEOUT, MAX_CHANNEL_TIMEOUT)
        raise ArgumentError, "Invalid 'channel_timeout' #{channel_timeout}. Must be between #{MIN_CHANNEL_TIMEOUT} and #{MAX_CHANNEL_TIMEOUT} (inclusive)"
      end

      @channel_timeout = channel_timeout
    end

    def client_ref=(client_ref)
      @client_ref = client_ref
    end

    def code_length=(code_length)
      unless code_length.between?(MIN_CODE_LENGTH, MAX_CODE_LENGTH)
        raise ArgumentError, "Invalid 'code_length' #{code_length}. Must be between #{MIN_CODE_LENGTH} and #{MAX_CODE_LENGTH} (inclusive)"
      end

      @code_length = code_length
    end

    def code=(code)
      @code = code
    end

    def to_h
      hash = Hash.new
      self.instance_variables.each do |ivar|
        hash[ivar.to_s.delete("@").to_sym] = self.instance_variable_get(ivar)
      end
      hash
    end
  end
end
