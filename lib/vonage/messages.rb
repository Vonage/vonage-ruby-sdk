# typed: strict
# frozen_string_literal: true

module Vonage
  class Messages < Namespace
    extend T::Sig

    self.host = :rest_host

    sig { params(id: String).returns(Vonage::Response) }
    def get(id)
      request('/search/message', params: {id: id})
    end

    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def search(params)
      request('/search/messages', params: params)
    end

    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def rejections(params)
      request('/search/rejections', params: params)
    end
  end
end
