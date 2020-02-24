# typed: false

module Nexmo
  class Client
    attr_reader :config

    def initialize(options = nil)
      @config = Nexmo.config.merge(options)
    end

    # @return [Signature]
    #
    def signature
      @signature ||= Signature.new(config)
    end

    # @return [Account]
    #
    def account
      @account ||= Account.new(config)
    end

    # @return [Alerts]
    #
    def alerts
      @alerts ||= Alerts.new(config)
    end

    # @return [Applications]
    #
    def applications
      @applications ||= Applications.new(config)
    end

    # @return [Calls]
    #
    def calls
      @calls ||= Calls.new(config)
    end

    # @return [Conversations]
    #
    def conversations
      @conversations ||= Conversations.new(config)
    end

    # @return [Conversions]
    #
    def conversions
      @conversions ||= Conversions.new(config)
    end

    # @return [Files]
    #
    def files
      @files ||= Files.new(config)
    end

    # @return [Messages]
    #
    def messages
      @messages ||= Messages.new(config)
    end

    # @return [NumberInsight]
    #
    def number_insight
      @number_insight ||= NumberInsight.new(config)
    end

    # @return [Numbers]
    #
    def numbers
      @numbers ||= Numbers.new(config)
    end

    # @return [PricingTypes]
    #
    def pricing
      @pricing ||= PricingTypes.new(config)
    end

    # @return [Redact]
    #
    def redact
      @redact ||= Redact.new(config)
    end

    # @return [Secrets]
    #
    def secrets
      @secrets ||= Secrets.new(config)
    end

    # @return [SMS]
    #
    def sms
      @sms ||= SMS.new(config)
    end

    # @return [TFA]
    #
    def tfa
      @tfa ||= TFA.new(config)
    end

    # @return [Verify]
    #
    def verify
      @verify ||= Verify.new(config)
    end
  end
end
