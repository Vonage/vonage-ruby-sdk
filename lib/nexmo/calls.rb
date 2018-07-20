# frozen_string_literal: true

module Nexmo
  class Calls < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

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

    def transfer(id, destination:)
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
  end
end
