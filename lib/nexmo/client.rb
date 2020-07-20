# typed: strict

module Nexmo
  class Client
    extend T::Sig

    sig { returns(Nexmo::Config) }
    attr_reader :config

    sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).void }
    def initialize(options = nil)
      @config = T.let(Nexmo.config.merge(options), Nexmo::Config)
    end

    # @return [Signature]
    #
    sig { returns(T.nilable(Nexmo::Signature)) }
    def signature
      @signature ||= T.let(Signature.new(config), T.nilable(Nexmo::Signature))
    end

    # @return [Account]
    #
    sig { returns(T.nilable(Nexmo::Account)) }
    def account
      @account ||= T.let(Account.new(config), T.nilable(Nexmo::Account))
    end

    # @return [Alerts]
    #
    sig { returns(T.nilable(Nexmo::Alerts)) }
    def alerts
      @alerts ||= T.let(Alerts.new(config), T.nilable(Nexmo::Alerts))
    end

    # @return [Applications]
    #
    sig { returns(T.nilable(Nexmo::Applications)) }
    def applications
      @applications ||= T.let(Applications.new(config), T.nilable(Nexmo::Applications))
    end

    # @return [Conversations]
    #
    sig { returns(T.nilable(Nexmo::Conversations)) }
    def conversations
      @conversations ||= T.let(Conversations.new(config), T.nilable(Nexmo::Conversations))
    end

    # @return [Conversions]
    #
    sig { returns(T.nilable(Nexmo::Conversions)) }
    def conversions
      @conversions ||= T.let(Conversions.new(config), T.nilable(Nexmo::Conversions))
    end

    # @return [Files]
    #
    sig { returns(T.nilable(Nexmo::Files)) }
    def files
      @files ||= T.let(Files.new(config), T.nilable(Nexmo::Files))
    end

    # @return [Messages]
    #
    sig { returns(T.nilable(Nexmo::Messages)) }
    def messages
      @messages ||= T.let(Messages.new(config), T.nilable(Nexmo::Messages))
    end

    # @return [NumberInsight]
    #
    sig { returns(T.nilable(Nexmo::NumberInsight)) }
    def number_insight
      @number_insight ||= T.let(NumberInsight.new(config), T.nilable(Nexmo::NumberInsight))
    end

    # @return [Numbers]
    #
    sig { returns(T.nilable(Nexmo::Numbers)) }
    def numbers
      @numbers ||= T.let(Numbers.new(config), T.nilable(Nexmo::Numbers))
    end

    # @return [PricingTypes]
    #
    sig { returns(T.nilable(Nexmo::PricingTypes)) }
    def pricing
      @pricing ||= T.let(PricingTypes.new(config), T.nilable(Nexmo::PricingTypes))
    end

    # @return [Redact]
    #
    sig { returns(T.nilable(Nexmo::Redact)) }
    def redact
      @redact ||= T.let(Redact.new(config), T.nilable(Nexmo::Redact))
    end

    # @return [Secrets]
    #
    sig { returns(T.nilable(Nexmo::Secrets)) }
    def secrets
      @secrets ||= T.let(Secrets.new(config), T.nilable(Nexmo::Secrets))
    end

    # @return [SMS]
    #
    sig { returns(T.nilable(Nexmo::SMS)) }
    def sms
      @sms ||= T.let(SMS.new(config), T.nilable(Nexmo::SMS))
    end

    # @return [TFA]
    #
    sig { returns(T.nilable(Nexmo::TFA)) }
    def tfa
      @tfa ||= T.let(TFA.new(config), T.nilable(Nexmo::TFA))
    end

    # @return [Verify]
    #
    sig { returns(T.nilable(Nexmo::Verify)) }
    def verify
      @verify ||= T.let(Verify.new(config), T.nilable(Nexmo::Verify))
    end

    # @return [Voice]
    #
    sig { returns(T.nilable(Nexmo::Voice)) }
    def voice
      @voice ||= T.let(Voice.new(config), T.nilable(Nexmo::Voice))
    end
  end
end
