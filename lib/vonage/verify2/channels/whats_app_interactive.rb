# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::WhatsAppInteractive

    attr_reader :channel, :to

    def initialize(to:)
      self.channel = 'whatsapp_interactive'
      self.to = to
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to.to_i).valid?
      @to = to
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
