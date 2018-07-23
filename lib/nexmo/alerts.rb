# frozen_string_literal: true

module Nexmo
  class Alerts < Namespace
    self.host = 'rest.nexmo.com'

    def list
      request('/sc/us/alert/opt-in/query/json')
    end

    def remove(params)
      request('/sc/us/alert/opt-in/manage/json', params: params, type: Post)
    end

    alias_method :resubscribe, :remove

    def send(params)
      request('/sc/us/alert/json', params: params, type: Post)
    end
  end
end
