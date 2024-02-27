# typed: strict
# frozen_string_literal: true

module Vonage
  class Conversation < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON
  end
end
