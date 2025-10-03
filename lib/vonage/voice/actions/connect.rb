# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Voice::Actions::Connect
    attr_accessor :endpoint, :from, :eventType, :timeout, :limit, :machineDetection, :advanced_machine_detection, :eventUrl, :eventMethod, :ringbackTone

    def initialize(attributes = {})
      @endpoint = attributes.fetch(:endpoint)
      @from = attributes.fetch(:from, nil)
      @eventType = attributes.fetch(:eventType, nil)
      @timeout = attributes.fetch(:timeout, nil)
      @limit = attributes.fetch(:limit, nil)
      @machineDetection = attributes.fetch(:machineDetection, nil)
      @advanced_machine_detection = attributes.fetch(:advanced_machine_detection, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
      @ringbackTone = attributes.fetch(:ringbackTone, nil)

      after_initialize!
    end

    def after_initialize!
      verify_endpoint

      if self.from
        verify_from
      end

      if self.eventType
        verify_event_type
      end

      if self.limit
        verify_limit
      end

      if self.machineDetection
        verify_machine_detection
      end

      if self.advanced_machine_detection
        verify_advanced_machine_detection
      end

      if self.eventUrl
        verify_event_url
      end

      if self.eventMethod
        verify_event_method
      end

      if self.ringbackTone
        verify_ringback_tone
      end
    end

    def verify_endpoint
      case self.endpoint[:type]
      when 'phone'
        raise ClientError.new("Expected 'number' value to be in E.164 format") unless Phonelib.parse(endpoint[:number].to_i).valid?
      when 'app'
        raise ClientError.new("'user' must be defined") unless endpoint[:user]
      when 'websocket'
        raise ClientError.new("Expected 'uri' value to be a valid URI") unless URI.parse(endpoint[:uri]).kind_of?(URI::Generic)
        raise ClientError.new("Expected 'content-type' parameter to be either 'audio/116;rate=16000' or 'audio/116;rate=8000") unless endpoint[:'content-type'] == 'audio/116;rate=16000' || endpoint[:'content-type'] == 'audio/116;rate=8000'
      when 'sip'
        raise ClientError.new("Expected 'uri' value to be a valid URI") unless URI.parse(endpoint[:uri]).kind_of?(URI::Generic) if endpoint[:uri]
        raise ClientError.new("`uri` must not be combined with `user` and `domain`") if endpoint[:uri] && (endpoint[:user] || endpoint[:domain])
        raise ClientError.new("You must provide both `user` and `domain`") if (endpoint[:user] && !endpoint[:domain]) || (endpoint[:domain] && !endpoint[:user])
      end
    end

    def verify_from
      raise ClientError.new("Invalid 'from' value, must be in E.164 format") unless Phonelib.parse(self.from.to_i).valid?
    end

    def verify_event_type
      raise ClientError.new("Invalid 'eventType' value, must be 'synchronous' if defined") unless self.eventType == 'synchronous'
    end

    def verify_limit
      raise ClientError.new("Invalid 'limit' value, must be between 0 and 7200 seconds") unless self.limit.to_i >= 0 && self.limit.to_i <= 7200
    end

    def verify_machine_detection
      raise ClientError.new("Invalid 'machineDetection' value, must be either: 'continue' or 'hangup' if defined") unless self.machineDetection == 'continue' || self.machineDetection == 'hangup'
    end

    def verify_advanced_machine_detection
      raise ClientError.new("Invalid 'advanced_machine_detection' value, must be a Hash") unless self.advanced_machine_detection.is_a?(Hash)
      verify_advanced_machine_detection_behavior if self.advanced_machine_detection[:behavior]
      verify_advanced_machine_detection_mode if self.advanced_machine_detection[:mode]
      verify_advanced_machine_detection_beep_timeout if self.advanced_machine_detection[:beep_timeout]
    end

    def verify_advanced_machine_detection_behavior
      raise ClientError.new("Invalid 'advanced_machine_detection[:behavior]' value, must be a `continue` or `hangup`") unless ['continue', 'hangup'].include?(self.advanced_machine_detection[:behavior])
    end

    def verify_advanced_machine_detection_mode
      raise ClientError.new("Invalid 'advanced_machine_detection[:mode]' value, must be a `detect` or `detect_beep`") unless ['detect', 'detect_beep'].include?(self.advanced_machine_detection[:mode])
    end

    def verify_advanced_machine_detection_beep_timeout
      raise ClientError.new("Invalid 'advanced_machine_detection[:beep_timeout]' value, must be between 45 and 120") unless self.advanced_machine_detection[:beep_timeout].between?(45, 120)
    end

    def verify_event_url
      unless self.eventUrl.is_a?(Array) && self.eventUrl.length == 1 && self.eventUrl[0].is_a?(String)
        raise ClientError.new("Expected 'eventUrl' parameter to be an Array containing a single string item")
      end

      uri = URI.parse(self.eventUrl[0])

      raise ClientError.new("Invalid 'eventUrl' value, array must contain a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.eventUrl
    end

    def verify_event_method
      valid_methods = ['GET', 'POST']

      raise ClientError.new("Invalid 'eventMethod' value. must be either: 'GET' or 'POST'") unless valid_methods.include?(self.eventMethod.upcase)
    end

    def verify_ringback_tone
      uri = URI.parse(self.ringbackTone)

      raise ClientError.new("Invalid 'ringbackTone' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.ringbackTone
    end

    def action
      create_connect!(self)
    end

    def create_connect!(builder)
      ncco = [
        {
          action: 'connect',
          endpoint: [
            create_endpoint(builder)
          ]
        }
      ]

      ncco[0].merge!(from: builder.from) if builder.from
      ncco[0].merge!(eventType: builder.eventType) if builder.eventType
      ncco[0].merge!(timeout: builder.timeout) if builder.timeout
      ncco[0].merge!(limit: builder.limit) if builder.limit
      ncco[0].merge!(machineDetection: builder.machineDetection) if builder.machineDetection
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod
      ncco[0].merge!(ringbackTone: builder.ringbackTone) if builder.ringbackTone

      ncco
    end

    def create_endpoint(builder)
      case builder.endpoint[:type]
      when 'phone'
        phone_endpoint(builder.endpoint)
      when 'app'
        app_endpoint(builder.endpoint)
      when 'websocket'
        websocket_endpoint(builder.endpoint)
      when 'sip'
        sip_endpoint(builder.endpoint)
      when 'vbc'
        vbc_endpoint(builder.endpoint)
      else
        raise ClientError.new("Invalid value for 'endpoint', please refer to the Vonage API Developer Portal https://developer.nexmo.com/voice/voice-api/ncco-reference#endpoint-types-and-values for a list of possible values")
      end
    end

    def phone_endpoint(endpoint_attrs)
      hash = {
        type: 'phone',
        number: endpoint_attrs[:number]
      }

      hash.merge!(dtmfAnswer: endpoint_attrs[:dtmfAnswer]) if endpoint_attrs[:dtmfAnswer]
      hash.merge!(onAnswer: endpoint_attrs[:onAnswer]) if endpoint_attrs[:onAnswer]

      hash
    end

    def app_endpoint(endpoint_attrs)
      {
        type: 'app',
        user: endpoint_attrs[:user]
      }
    end

    def websocket_endpoint(endpoint_attrs)
      hash = {
        type: 'websocket',
        uri: endpoint_attrs[:uri],
        :'content-type' => endpoint_attrs[:'content-type']
      }

      hash.merge!(headers: endpoint_attrs[:headers]) if endpoint_attrs[:headers]

      hash
    end

    def sip_endpoint(endpoint_attrs)
      hash = {
        type: 'sip'
      }

      hash.merge!(uri: endpoint_attrs[:uri]) if endpoint_attrs[:uri]
      hash.merge!(user: endpoint_attrs[:user]) if endpoint_attrs[:user]
      hash.merge!(domain: endpoint_attrs[:domain]) if endpoint_attrs[:domain]
      hash.merge!(headers: endpoint_attrs[:headers]) if endpoint_attrs[:headers]
      hash.merge!(standardHeaders: endpoint_attrs[:standardHeaders]) if endpoint_attrs[:standardHeaders]

      hash
    end

    def vbc_endpoint(endpoint_attrs)
      {
        type: 'vbc',
        extension: endpoint_attrs[:extension]
      }
    end
  end
end
