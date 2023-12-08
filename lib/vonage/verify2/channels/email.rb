# typed: true
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class Verify2::Channels::Email

    attr_reader :channel, :to, :from

    def initialize(to:, from: nil)
      self.channel = 'email'
      self.to = to
      self.from = from unless from.nil?
    end

    def to=(to)
      @to = to
    end

    def from=(from)
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
