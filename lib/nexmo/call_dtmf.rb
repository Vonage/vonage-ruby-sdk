# frozen_string_literal: true

module Nexmo
  class CallDTMF < Namespace
    def send(id, params)
      request('/v1/calls/' + id + '/dtmf', params: params, type: Put)
    end

    private

    def authorization_header?
      true
    end

    def json_body?
      true
    end
  end
end
