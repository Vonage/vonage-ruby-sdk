# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::SilentAuth

    attr_reader :channel, :to, :sandbox
    attr_accessor :redirect_url

    def initialize(to:, redirect_url: nil, sandbox: false)
      self.channel = 'silent_auth'
      self.to = to
      self.redirect_url = redirect_url if redirect_url
      self.sandbox = sandbox
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to.to_i).valid?
      @to = to
    end

    def sandbox=(sandbox)
      raise ArgumentError, "Invalid 'sandbox' value #{sandbox}. Expected to be boolean value" unless [true, false].include? sandbox
      @sandbox = sandbox
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
