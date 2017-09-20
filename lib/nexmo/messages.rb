# frozen_string_literal: true

module Nexmo
  class Messages < Namespace
    def get(id)
      request('/search/message', params: {id: id})
    end

    def search(params)
      request('/search/messages', params: params)
    end

    def rejections(params)
      request('/search/rejections', params: params)
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
