# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Captions < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    def start(session_id:, token:, **params)
      request(
        '/v2/project/' + @config.application_id + '/captions',
        params: camelcase(params.merge({sessionId: session_id, token: token})),
        type: Post)
    end

    def stop(captions_id:)
      request('/v2/project/' + @config.application_id + '/captions/' + captions_id + '/stop', type: Post)
    end
  end
end
