# frozen_string_literal: true

module Nexmo
  class CallDTMF < Namespace
    self.authentication = BearerToken

    def send(id, params)
      request('/v1/calls/' + id + '/dtmf', params: params, type: Put)
    end

    private

    def json_body?
      true
    end
  end
end
