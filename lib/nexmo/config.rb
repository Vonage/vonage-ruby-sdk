# typed: true
# frozen_string_literal: true
require 'logger'

module Nexmo
  class Config
    extend T::Sig

    sig { void }
    def initialize
      self.api_host = 'api.nexmo.com'
      self.api_key = T.let(ENV['NEXMO_API_KEY'], T.nilable(String))
      self.api_secret = T.let(ENV['NEXMO_API_SECRET'], T.nilable(String))
      self.application_id = ENV['NEXMO_APPLICATION_ID']
      self.logger = (defined?(Rails.logger) && Rails.log) || Nexmo::Logger.new(nil)
      self.private_key = ENV['NEXMO_PRIVATE_KEY_PATH'] ? File.read(T.must(ENV['NEXMO_PRIVATE_KEY_PATH'])) : ENV['NEXMO_PRIVATE_KEY']
      self.rest_host = 'rest.nexmo.com'
      self.signature_secret = ENV['NEXMO_SIGNATURE_SECRET']
      self.signature_method = ENV['NEXMO_SIGNATURE_METHOD'] || 'md5hash'
      self.token = T.let(nil, T.nilable(String))
    end

    # Merges the config with the given options hash.
    #
    # @return [Nexmo::Config]
    #
    sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).returns(Nexmo::Config) }
    def merge(options)
      return self if options.nil? || options.empty?

      options.each_with_object(dup) do |(name, value), config|
        config.write_attribute(name, value)
      end
    end

    sig { returns(String) }
    attr_accessor :api_host

    # Returns the value of attribute api_key.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    sig { returns(T.nilable(String)) }
    def api_key
      @api_key = T.let(@api_key, T.nilable(String))
      unless @api_key
        raise AuthenticationError.new('No API key provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @api_key
    end

    sig { params(api_key: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :api_key

    # Returns the value of attribute api_secret.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    sig { returns(T.nilable(String)) }
    def api_secret
      @api_secret = T.let(@api_secret, T.nilable(String))
      unless @api_secret
        raise AuthenticationError.new('No API secret provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @api_secret
    end

    sig { params(api_secret: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :api_secret

    # Returns the value of attribute application_id.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    sig { returns(T.nilable(String)) }
    def application_id
      @application_id = T.let(@application_id, T.nilable(String))
      unless @application_id
        raise AuthenticationError.new('No application_id provided. ' \
          'Either provide an application_id, or set an auth token. ' \
          'You can add new applications from the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @application_id
    end

    sig { params(application_id: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :application_id

    sig { returns(T.nilable(String)) }
    attr_accessor :app_name

    sig { returns(T.nilable(String)) }
    attr_accessor :app_version

    # Returns the value of attribute http.
    #
    # @return [Nexmo::HTTP::Options]
    #
    sig { returns(T.nilable(Nexmo::HTTP::Options)) }
    attr_reader :http

    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T.nilable(Nexmo::HTTP::Options)) }
    def http=(hash)
      @http = T.let(nil, T.nilable(Nexmo::HTTP::Options))
      @http = Nexmo::HTTP::Options.new(hash)
    end

    # Returns the value of attribute logger.
    #
    # @return [Nexmo::Logger]
    #
    sig { returns(T.nilable(Nexmo::Logger)) }
    attr_reader :logger

    # @return [Nexmo::Logger]
    #
    sig { params(logger: T.any(::Logger, Nexmo::Logger)).returns(T.nilable(Nexmo::Logger)) }
    def logger=(logger)
      @logger = T.let(Logger.new(logger), T.nilable(Nexmo::Logger))
    end

    # Returns the value of attribute private_key.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    sig { returns(T.nilable(String)) }
    def private_key
      @private_key = T.let(@private_key, T.nilable(String))
      unless @private_key
        raise AuthenticationError.new('No private_key provided. ' \
          'Either provide a private_key, or set an auth token. ' \
          'You can add new applications from the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @private_key
    end

    sig { params(private_key: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :private_key

    sig { returns(String) }
    attr_accessor :rest_host

    # Returns the value of attribute signature_secret.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    sig { returns(T.nilable(String)) }
    def signature_secret
      @signature_secret = T.let(@signature_secret, T.nilable(String))
      unless @signature_secret
        raise AuthenticationError.new('No signature_secret provided. ' \
          'You can find your signature secret in the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/signing-messages for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @signature_secret
    end

    sig { params(signature_secret: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :signature_secret

    sig { returns(String) }
    attr_accessor :signature_method

    # Returns the value of attribute token, or a temporary short lived token.
    #
    # @return [String]
    #
    sig { returns(T.nilable(String)) }
    def token
      @token = T.let(nil, T.nilable(String))
      @token || JWT.generate({application_id: application_id}, T.must(private_key))
    end

    sig { params(token: T.nilable(String)).returns(T.nilable(String)) }
    attr_writer :token

    protected

    sig { params(name: Symbol, value: T.nilable(T.untyped)).void }
    def write_attribute(name, value)
      public_send(:"#{name}=", value)
    end
  end
end
