# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Webhooks < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON


  end
end
