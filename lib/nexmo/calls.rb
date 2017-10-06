# frozen_string_literal: true

module Nexmo
  class Calls < Namespace
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

    def authorization_header?
      true
    end
  end
end
