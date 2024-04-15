# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Captions < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    
  end
end
