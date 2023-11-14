# typed: strict

module Vonage
  class Client
    extend T::Sig

    sig { returns(Vonage::Config) }
    attr_reader :config

    sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).void }
    def initialize(options = nil)
      @config = T.let(Vonage.config.merge(options), Vonage::Config)
    end

    # @return [Signature]
    #
    sig { returns(T.nilable(Vonage::Signature)) }
    def signature
      @signature ||= T.let(Signature.new(config), T.nilable(Vonage::Signature))
    end

    # @return [Account]
    #
    sig { returns(T.nilable(Vonage::Account)) }
    def account
      @account ||= T.let(Account.new(config), T.nilable(Vonage::Account))
    end

    # @return [Alerts]
    #
    sig { returns(T.nilable(Vonage::Alerts)) }
    def alerts
      @alerts ||= T.let(Alerts.new(config), T.nilable(Vonage::Alerts))
    end

    # @return [Applications]
    #
    sig { returns(T.nilable(Vonage::Applications)) }
    def applications
      @applications ||= T.let(Applications.new(config), T.nilable(Vonage::Applications))
    end

    # @return [Conversations]
    #
    sig { returns(T.nilable(Vonage::Conversations)) }
    def conversations
      @conversations ||= T.let(Conversations.new(config), T.nilable(Vonage::Conversations))
    end

    # @return [Conversions]
    #
    sig { returns(T.nilable(Vonage::Conversions)) }
    def conversions
      @conversions ||= T.let(Conversions.new(config), T.nilable(Vonage::Conversions))
    end

    # @return [Files]
    #
    sig { returns(T.nilable(Vonage::Files)) }
    def files
      @files ||= T.let(Files.new(config), T.nilable(Vonage::Files))
    end

    # @return [Meetings]
    #
    sig { returns(T.nilable(Vonage::Meetings)) }
    def meetings
      @meetings ||= T.let(Meetings.new(config), T.nilable(Vonage::Meetings))
    end

    # @return [Messages]
    #
    sig { returns(T.nilable(Vonage::Messages)) }
    def messages
      @messages ||= T.let(Messages.new(config), T.nilable(Vonage::Messages))
    end

    # @return [Messaging]
    #
    sig { returns(T.nilable(Vonage::Messaging)) }
    def messaging
      @messaging ||= T.let(Messaging.new(config), T.nilable(Vonage::Messaging))
    end

    # @return [NumberInsight]
    #
    sig { returns(T.nilable(Vonage::NumberInsight)) }
    def number_insight
      @number_insight ||= T.let(NumberInsight.new(config), T.nilable(Vonage::NumberInsight))
    end

    # @return [Numbers]
    #
    sig { returns(T.nilable(Vonage::Numbers)) }
    def numbers
      @numbers ||= T.let(Numbers.new(config), T.nilable(Vonage::Numbers))
    end

    # @return [PricingTypes]
    #
    sig { returns(T.nilable(Vonage::PricingTypes)) }
    def pricing
      @pricing ||= T.let(PricingTypes.new(config), T.nilable(Vonage::PricingTypes))
    end

    # @return [ProactiveConnect]
    #
    sig { returns(T.nilable(Vonage::ProactiveConnect)) }
    def proactive_connect
      @proactive_connect ||= T.let(ProactiveConnect.new(config), T.nilable(Vonage::ProactiveConnect))
    end

    # @return [Redact]
    #
    sig { returns(T.nilable(Vonage::Redact)) }
    def redact
      @redact ||= T.let(Redact.new(config), T.nilable(Vonage::Redact))
    end

    # @return [Secrets]
    #
    sig { returns(T.nilable(Vonage::Secrets)) }
    def secrets
      @secrets ||= T.let(Secrets.new(config), T.nilable(Vonage::Secrets))
    end

    # @return [SMS]
    #
    sig { returns(T.nilable(Vonage::SMS)) }
    def sms
      @sms ||= T.let(SMS.new(config), T.nilable(Vonage::SMS))
    end

    # @return [Subaccounts]
    #
    sig { returns(T.nilable(Vonage::Subaccounts)) }
    def subaccounts
      @subaccounts ||= T.let(Subaccounts.new(config), T.nilable(Vonage::Subaccounts))
    end

    # @return [TFA]
    #
    sig { returns(T.nilable(Vonage::TFA)) }
    def tfa
      @tfa ||= T.let(TFA.new(config), T.nilable(Vonage::TFA))
    end

    # @return [Users]
    #
    sig { returns(T.nilable(Vonage::Users)) }
    def users
      @users ||= T.let(Users.new(config), T.nilable(Vonage::Users))
    end

    # @return [Verify]
    #
    sig { returns(T.nilable(Vonage::Verify)) }
    def verify
      @verify ||= T.let(Verify.new(config), T.nilable(Vonage::Verify))
    end
    
    # @return [Verify2]
    #
    sig { returns(T.nilable(Vonage::Verify2)) }
    def verify2
      @verify2 ||= T.let(Verify2.new(config), T.nilable(Vonage::Verify2))
    end

    # @return [Video]
    #
    sig { returns(T.nilable(Vonage::Video)) }
    def video
      @video ||= T.let(Video.new(config), T.nilable(Vonage::Video))

    # @return [Voice]
    #
    sig { returns(T.nilable(Vonage::Voice)) }
    def voice
      @voice ||= T.let(Voice.new(config), T.nilable(Vonage::Voice))
    end
  end
end
