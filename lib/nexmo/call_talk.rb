# frozen_string_literal: true

module Nexmo
  class CallTalk < Namespace
    self.authentication = BearerToken

    def start(id, params)
      request('/v1/calls/' + id + '/talk', params: params, type: Put)
    end

    def stop(id)
      request('/v1/calls/' + id + '/talk', type: Delete)
    end

    private

    def json_body?
      true
    end
  end
end
