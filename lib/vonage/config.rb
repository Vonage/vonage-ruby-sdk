# frozen_string_literal: true
require 'logger'

module Vonage
  class Config

    def initialize
      self.api_host = 'api.nexmo.com'
      self.api_key = ENV['VONAGE_API_KEY']
      self.api_secret = ENV['VONAGE_API_SECRET']
      self.application_id = ENV['VONAGE_APPLICATION_ID']
      self.logger = (defined?(::Rails.logger) && ::Rails.logger) || Vonage::Logger.new(nil)
      self.private_key = ENV['VONAGE_PRIVATE_KEY_PATH'] ? File.read(ENV['VONAGE_PRIVATE_KEY_PATH']) : ENV['VONAGE_PRIVATE_KEY']
      self.rest_host = 'rest.nexmo.com'
      self.signature_secret = ENV['VONAGE_SIGNATURE_SECRET']
      self.signature_method = ENV['VONAGE_SIGNATURE_METHOD'] || 'md5hash'
      self.token = nil
    end

    # Merges the config with the given options hash.
    #
    # @return [Vonage::Config]
    #
    def merge(options)
      return self if options.nil? || options.empty?

      options.each_with_object(dup) do |(name, value), config|
        config.write_attribute(name, value)
      end
    end

    attr_accessor :api_host

    # Returns the value of attribute api_key.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    def api_key
      unless @api_key
        raise AuthenticationError.new('No API key provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @api_key
    end

    attr_writer :api_key

    # Returns the value of attribute api_secret.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    def api_secret
      unless @api_secret
        raise AuthenticationError.new('No API secret provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @api_secret
    end

    attr_writer :api_secret

    # Returns the value of attribute application_id.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    def application_id
      unless @application_id
        raise AuthenticationError.new('No application_id provided. ' \
          'Either provide an application_id, or set an auth token. ' \
          'You can add new applications from the Vonage dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @application_id
    end

    attr_writer :application_id

    attr_accessor :app_name

    attr_accessor :app_version

    # Returns the value of attribute http.
    #
    # @return [Vonage::HTTP::Options]
    #
    attr_reader :http

    def http=(hash)
      @http = nil
      @http = Vonage::HTTP::Options.new(hash)
    end

    # Returns the value of attribute logger.
    #
    # @return [Vonage::Logger]
    #
    attr_reader :logger

    # @return [Vonage::Logger]
    #
    def logger=(logger)
      @logger = Logger.new(logger)
    end

    # Returns the value of attribute private_key.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    def private_key
      unless @private_key
        raise AuthenticationError.new('No private_key provided. ' \
          'Either provide a private_key, or set an auth token. ' \
          'You can add new applications from the Vonage dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @private_key
    end

    attr_writer :private_key

    attr_accessor :rest_host

    # Returns the value of attribute signature_secret.
    #
    # @return [String]
    #
    # @raise [AuthenticationError]
    #
    def signature_secret
      unless @signature_secret
        raise AuthenticationError.new('No signature_secret provided. ' \
          'You can find your signature secret in the Vonage dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/signing-messages for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      @signature_secret
    end

    attr_writer :signature_secret

    attr_accessor :signature_method

    # Returns the value of attribute token, or a temporary short lived token.
    #
    # @return [String]
    #
    def token
      @token = nil
      @token || JWT.generate({application_id: application_id}, private_key)
    end

    attr_writer :token

    protected

    def write_attribute(name, value)
      public_send(:"#{name}=", value)
    end
  end
end
