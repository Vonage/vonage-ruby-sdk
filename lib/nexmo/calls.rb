# frozen_string_literal: true

module Nexmo
  class Calls < Namespace
    self.authentication = BearerToken

    def create(params)
      request('/v1/calls', params: params, type: Post)
    end

    def list(params = nil)
      request('/v1/calls', params: params)
    end

    def get(id)
      request('/v1/calls/' + id)
    end

    def update(id, params)
      request('/v1/calls/' + id, params: params, type: Put)
    end

    def hangup(id)
      update(id, action: 'hangup')
    end

    def mute(id)
      update(id, action: 'mute')
    end

    def unmute(id)
      update(id, action: 'unmute')
    end

    def earmuff(id)
      update(id, action: 'earmuff')
    end

    def unearmuff(id)
      update(id, action: 'unearmuff')
    end

    def transfer(id, destination: nil)
      # Ruby 2.0.0 does not support the syntax for required keyword arguments
      # that was introduced in Ruby 2.1. The following line and the nil default
      # can be removed when dropping support for Ruby 2.0.0.
      raise ArgumentError, 'missing keyword: destination' if destination.nil?

      update(id, action: 'transfer', destination: destination)
    end

    def stream
      @stream ||= CallStream.new(@client)
    end

    def talk
      @talk ||= CallTalk.new(@client)
    end

    def dtmf
      @dtmf ||= CallDTMF.new(@client)
    end

    private

    def json_body?
      true
    end
  end
end
