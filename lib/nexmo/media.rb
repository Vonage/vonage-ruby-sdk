# frozen_string_literal: true

module Nexmo
  class Media < Namespace
    def upload(url: nil, filedata: nil, filename: nil)
      params = []
      params << ['url', url] if url
      params << ['filedata', filedata] unless url
      params << ['filename', filename] if filename

      request('/v3/media', params: params, type: Post, multipart: true)
    end

    def list(params = nil)
      request('/v3/media', params: params)
    end

    def get(id)
      request('/v3/media/' + id + '/info')
    end

    def delete(id)
      request('/v3/media/' + id + '/info', type: Delete)
    end

    private

    def authorization_header?
      true
    end
  end
end
