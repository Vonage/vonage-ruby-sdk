# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::WhatsApp

    attr_reader :channel, :to, :from

    def initialize(to:, from: nil)
      self.channel = 'whatsapp'
      self.to = to
      self.from = from unless from.nil?
    end

    def to=(to)
      raise ArgumentError, "Invalid 'to' value #{to}. Expected to be in E.164 format" unless Phonelib.parse(to.to_i).valid?
      @to = to
    end

    def from=(from)
      raise ArgumentError, "Invalid 'from' value #{from}. Expected to be in E.164 format" unless Phonelib.parse(from.to_i).valid?
      @from = from
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
