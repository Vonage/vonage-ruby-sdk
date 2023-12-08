# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::SMS
    APP_HASH_LENGTH = 11

    attr_reader :channel, :to, :app_hash

    def initialize(to:, app_hash: nil)
      self.channel = 'sms'
      self.to = to
      self.app_hash = app_hash unless app_hash.nil?
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to).valid?
      @to = to
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
  end
end
