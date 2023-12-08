# typed: true
# frozen_string_literal: true
require 'phonelib'
require 'uri'

module Vonage
  class Verify2::Channels::SilentAuth

    attr_reader :channel, :to, :sandbox, :redirect_url

    def initialize(to:, redirect_url: nil, sandbox: nil)
      self.channel = 'silent_auth'
      self.to = to
      self.redirect_url = redirect_url unless redirect_url.nil?
      self.sandbox = sandbox unless sandbox.nil?
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to.to_i).valid?
      @to = to
    end

    def redirect_url=(redirect_url)
      raise ArgumentError, "Invalid 'to' value #{redirect_url}. Expected to be a valid URL" unless URI.parse(redirect_url).is_a?(URI::HTTP)
      @redirect_url = redirect_url
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
