# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Renders < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    def start(session_id:, token:, url:, **params)
      request(
        '/v2/project/' + @config.application_id + '/render',
        params: camelcase(params.merge({sessionId: session_id, token: token, url: url})),
        type: Post)
    end

    def stop(experience_composer_id:)
      request('/v2/project/' + @config.application_id + '/render/' + experience_composer_id, type: Delete)
    end

    def info(experience_composer_id:)
      request('/v2/project/' + @config.application_id + '/render/' + experience_composer_id)
    end

    def list(**params)
      path = '/v2/project/' + @config.application_id + '/render'
      path += "?#{Params.encode(camelcase(params))}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
