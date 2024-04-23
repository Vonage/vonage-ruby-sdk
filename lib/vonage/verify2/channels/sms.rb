# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::SMS
    APP_HASH_LENGTH = 11

    attr_reader :channel, :to, :from, :entity_id, :content_id, :app_hash

    def initialize(to:, app_hash: nil)
      self.channel = 'sms'
      self.to = to
      self.app_hash = app_hash unless app_hash.nil?
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to).valid?
      @to = to
    end

    def from=(from)
      validate_from(from)
      @from = from
    end

    def entity_id=(entity_id)
      raise ArgumentError, "Invalid 'entity_id' value #{entity_id}. Length must be between 1 and 20 characters." unless entity_id.length.between?(1, 20)
      @entity_id = entity_id
    end

    def content_id=(content_id)
      raise ArgumentError, "Invalid 'content_id' value #{content_id}. Length must be between 1 and 20 characters ." unless content_id.length.between?(1, 20)
      @content_id = content_id
    end

    def app_hash=(app_hash)
      raise ArgumentError, "Invalid 'app_hash' value #{app_hash}. Length must be #{APP_HASH_LENGTH}" unless app_hash.length == APP_HASH_LENGTH
      @app_hash = app_hash
    end

    def to_h
      hash = Hash.new
      self.instance_variables.each do |ivar|
        hash[ivar.to_s.delete("@").to_sym] = self.instance_variable_get(ivar)
      end
      hash
    end

    private

    attr_writer :channel

    def validate_from(from)
      if from.match?(/\D/)
        raise ArgumentError, "Invalid alpha-numeric 'from' value #{from}. Length must be between 3 and 11 characters." unless from.length.between?(3, 11)
      else
        raise ArgumentError, "Invalid numeric 'from' value #{from}. Length must be between 11 and 15 characters." unless from.length.between?(11, 15)
        raise ArgumentError, "Invalid 'from' value #{from}. Expected to be in E.164 format" unless Phonelib.parse(from).valid?
      end
    end
  end
end
