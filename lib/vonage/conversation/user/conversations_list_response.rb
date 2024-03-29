# typed: true

class Vonage::Conversation::User::ConversationsListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.conversations.each { |item| yield item }
  end
end
