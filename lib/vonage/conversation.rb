# typed: strict
# frozen_string_literal: true

module Vonage
  class Conversation < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    def list(**params)
      request('/v1/conversations', params: params, response_class: ListResponse)
    end

    def create(**params)
      request('/v1/conversations', params: params, type: Post)
    end

    def find(conversation_id:)
      request("/v1/conversations/#{conversation_id}")
    end

    def update(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}", params: params, type: Put)
    end

    def delete(conversation_id:)
      request("/v1/conversations/#{conversation_id}", type: Delete)
    end

    # @return [User]
    sig { returns(T.nilable(Vonage::Conversation::User)) }
    def user
      @user ||= User.new(@config)
    end

    # @return [Member]
    sig { returns(T.nilable(Vonage::Conversation::Member)) }
    def member
      @member ||= Member.new(@config)
    end

    # @return [Event]
    sig { returns(T.nilable(Vonage::Conversation::Event)) }
    def event
      @event ||= Event.new(@config)
    end
  end
end
