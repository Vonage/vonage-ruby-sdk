# frozen_string_literal: true

module Nexmo
  class CallDTMF < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def send(id, params)
      request('/v1/calls/' + id + '/dtmf', params: params, type: Put)
    end
  end
end
